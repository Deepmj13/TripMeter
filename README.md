# Tripmeter

Offline-first collaborative trip expense manager. A Flutter client keeps a
per-user encrypted local database and syncs through a NestJS API backed by
MongoDB.

- Product and technical plan: [`implementation.md`](implementation.md)
- API contract: [`backend/openapi.json`](backend/openapi.json)
- Generated live docs: `http://localhost:3000/docs` while the API is running

## Repository layout

```
backend/   NestJS modular monolith (REST API, MongoDB, OpenAPI generation)
app/       Flutter application (Riverpod, Drift + SQLCipher, Dio, GoRouter)
```

## Prerequisites

| Tool | Version |
| --- | --- |
| Node.js | 20+ (developed on 26) |
| Flutter | 3.47+ / Dart 3.13+ |
| MongoDB | 7+ running as a **single-node replica set** |

Transactions are required for trips, invitations, expenses, settlements and
the transactional outbox, so a standalone `mongod` without a replica set will
fail writes.

### Start a local replica set

With Docker:

```bash
docker run --name tripmeter-mongo -p 27017:27017 -d mongo:7 \
  --replSet rs0 --bind_ip_all
docker exec tripmeter-mongo mongosh --eval "rs.initiate()"
```

Or with a local `mongod`:

```bash
mongod --dbpath ./data --replSet rs0 --bind_ip 127.0.0.1
mongosh --eval "rs.initiate()"
```

## Backend

```bash
cd backend
npm install
cp .env.example .env        # then edit secrets
npm run start:dev
```

Key environment variables (full list in `backend/.env.example`):

| Variable | Purpose |
| --- | --- |
| `MONGODB_URI` | Replica-set connection string, e.g. `mongodb://localhost:27017/tripmeter?replicaSet=rs0` |
| `MONGODB_DB_NAME` | Database name used by migrations/index setup |
| `JWT_ACCESS_SECRET` | Long random secret for access tokens |
| `APP_BASE_URL` | Public API base URL used in generated links |
| `CORS_ORIGINS` | Allowed origins; `*` during development |
| `EMAIL_PROVIDER_API_KEY` | Optional Resend key; without it emails are logged |
| `FIREBASE_PROJECT_ID` | Optional push project; device push delivery is deferred |

The API is served under `/v1`. Health checks:

- `GET /v1/health` – liveness
- `GET /v1/health/ready` – readiness (pings MongoDB)

### Useful commands

```bash
npm run build          # compile to dist/
npm run test           # unit tests (money + balance engine)
npm run test:e2e       # gated API workflow tests, requires MongoDB
npm run openapi        # regenerate openapi.json (no DB required)
```

`npm run test:e2e` creates a randomized database derived from `MONGODB_URI`
(or `MONGODB_TEST_URI`) and drops it afterwards, so it never touches your
development data. When neither variable is set the suite is skipped.

## Flutter app

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://localhost:3000/v1
```

Default API URLs when `API_BASE_URL` is omitted:

- Release builds: `https://tripmeter.onrender.com/v1`
- Android emulator (debug): `http://10.0.2.2:3000/v1`
- Everything else (debug): `http://localhost:3000/v1`

Pass `--dart-define=API_BASE_URL=...` to override the default in any build mode.

Local databases are encrypted with SQLite3MultipleCiphers. The database key is
generated per user and stored in the platform secure storage, so a single
installation can hold separate local datasets for different accounts.

Debug builds allow cleartext HTTP on Android and local networking on iOS. For
physical-device testing, point `API_BASE_URL` at your machine's LAN address and
make sure the backend binds to that interface.

### Deep links

The app registers the `tripmeter` custom scheme:

| Flow | Link |
| --- | --- |
| Password reset | `tripmeter://reset-password?token=...` |
| Trip invitation | `tripmeter://invitations/accept?token=...` |

An invitation token received before sign-in is kept in secure storage and
applied automatically after authentication.

### Useful commands

```bash
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs   # after Drift/model changes
```

## Architecture notes

### Backend

- Modular monolith: auth, users, trips, members, invitations, expenses,
  balances/suggestions, settlements, sync, notifications, health, retention.
- Money is always integer minor units. Amounts are bounded by
  `MAX_AMOUNT_MINOR`; splits must sum exactly to the expense amount.
- Equal splits are allocated deterministically: sorted member ids receive the
  floor share, remainder cents go to the lowest ids.
- Monetary writes run inside a MongoDB transaction via
  `MongoTransactionService.run()`.
- Mutating endpoints require an `Idempotency-Key`. The key plus a request hash
  is stored so a retry replays the original response instead of double-writing.
- Updates require `If-Match: "<version>"`. Missing header → `428
  PRECONDITION_REQUIRED`; stale version → `409` with a domain conflict code.
- Every committed change also writes a user-level and/or per-trip change event
  in the same transaction. The feeds are the source of truth for offline
  clients and support cursor replay.
- Client-created entities may supply a UUID `id`; the server validates and
  stores it so local and server ids match.

### Flutter client

- Local-first: every write is applied to the local database and recorded in a
  durable outbox in the same transaction.
- The outbox operation id doubles as the idempotency key; retries reuse the
  exact stored payload so a request hash mismatch cannot occur.
- Sync cycle order: pull user feed (applies access revocations first) → push
  outbox → pull each trip feed → pull the user feed again.
- Responses from successful writes replace the pending local row; trip change
  events are applied in sequence order and are idempotent.
- A version/state conflict, terminal 4xx or exhausted retry budget becomes an
  explicit conflict record. The local overlay is cleared so the next pull can
  apply the server state without re-raising the same conflict.
- Cursor expiry or a first-time cursor falls back to a full snapshot; pending
  local rows are preserved while the snapshot is applied.

## Current limitations

- Email and push delivery are stubbed to structured logs. Provide
  `EMAIL_PROVIDER_API_KEY` to enable Resend HTTP email.
- Firebase Cloud Messaging client registration is not wired into the Flutter
  app yet; the backend push outbox records are produced.
- Payments between members are informational settlement records; there is no
  payment-provider integration.
