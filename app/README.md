# Tripmeter Flutter app

The offline-first client for Tripmeter. See the [root README](../README.md) for
the full setup, backend and architecture notes.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=http://localhost:3000/v1
```

`API_BASE_URL` must include the `/v1` prefix. Without the define the app uses
`http://10.0.2.2:3000/v1` on the Android emulator and
`http://localhost:3000/v1` elsewhere.

## Layout

```
lib/
  app/         bootstrap, router, service container, app shell
  core/        auth/session, encrypted database, network, sync, deep links
  features/    auth, trips, members, invitations, expenses, balances,
               settlements, profile, conflicts
  shared/      models, money utilities, theme, widgets
test/          money/balance unit tests and local database/outbox tests
```

## Checks

```bash
flutter analyze
flutter test
```
