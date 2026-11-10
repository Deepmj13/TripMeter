import { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { getConnectionToken } from '@nestjs/mongoose';
import { randomUUID } from 'crypto';
import { Connection } from 'mongoose';
import request from 'supertest';
import { AppModule } from '../src/app.module';

/**
 * These tests require a MongoDB replica set because every write that matters
 * runs in a transaction. Set `MONGODB_TEST_URI` (or `MONGODB_URI`) to a replica
 * set connection string to run them; otherwise the suite is skipped.
 *
 * A random database name is appended so a developer database is never touched.
 */
const baseUri = process.env.MONGODB_TEST_URI ?? process.env.MONGODB_URI;
const describeWithMongo = baseUri ? describe : describe.skip;

describeWithMongo('TripMeter API (e2e)', () => {
  let app: INestApplication;
  let connection: Connection;
  let databaseName: string;

  const server = () => app.getHttpServer();
  const auth = (token: string) => ({
    Authorization: `Bearer ${token}`,
  });

  async function register(name: string) {
    const email = `${name.toLowerCase()}-${randomUUID()}@example.com`;
    const response = await request(server())
      .post('/v1/auth/register')
      .send({ name, email, password: 'correct horse battery' })
      .expect(201);
    const session = response.body.data as {
      accessToken: string;
      user: { id: string };
    };
    return session;
  }

  beforeAll(async () => {
    databaseName = `tripmeter_e2e_${randomUUID().replace(/-/g, '')}`;
    const url = new URL(baseUri!);
    url.pathname = `/${databaseName}`;
    process.env.MONGODB_URI = url.toString();

    const moduleRef = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleRef.createNestApplication();
    app.setGlobalPrefix('v1');
    await app.init();
    connection = app.get<Connection>(getConnectionToken());
  });

  afterAll(async () => {
    if (connection) {
      await connection.dropDatabase();
    }
    await app?.close();
  });

  it('reports readiness', async () => {
    const response = await request(server()).get('/v1/health/ready').expect(200);
    expect(response.body.data.status).toBe('ready');
  });

  it('supports the offline-first trip workflow', async () => {
    const owner = await register('Owner');
    const ownerToken = owner.accessToken;

    const tripKey = randomUUID();
    const tripPayload = { name: 'Goa 2026', currency: 'INR' };
    const created = await request(server())
      .post('/v1/trips')
      .set(auth(ownerToken))
      .set('Idempotency-Key', tripKey)
      .send(tripPayload)
      .expect(201);
    const tripId = created.body.data.trip.id as string;
    const ownerMemberId = created.body.data.membership.id as string;

    // Replaying the same key and body returns the stored response.
    const replay = await request(server())
      .post('/v1/trips')
      .set(auth(ownerToken))
      .set('Idempotency-Key', tripKey)
      .send(tripPayload)
      .expect(201);
    expect(replay.body.data.trip.id).toBe(tripId);

    const snapshot = await request(server())
      .get(`/v1/trips/${tripId}/snapshot`)
      .set(auth(ownerToken))
      .expect(200);
    expect(snapshot.body.data.trip.id).toBe(tripId);
    expect(snapshot.body.data.members).toHaveLength(1);
    expect(snapshot.body.data.sequence).toBeGreaterThan(0);

    const guest = await request(server())
      .post(`/v1/trips/${tripId}/members`)
      .set(auth(ownerToken))
      .set('Idempotency-Key', randomUUID())
      .send({ displayName: 'Travel companion' })
      .expect(201);
    const guestMemberId = guest.body.data.id as string;

    const expense = await request(server())
      .post(`/v1/trips/${tripId}/expenses`)
      .set(auth(ownerToken))
      .set('Idempotency-Key', randomUUID())
      .send({
        title: 'Dinner',
        amountMinor: 1000,
        paidByMemberId: ownerMemberId,
        splitType: 'equal',
        participantMemberIds: [ownerMemberId, guestMemberId],
        expenseDate: '2026-02-01',
        category: 'food',
      })
      .expect(201);
    const expenseId = expense.body.data.id as string;
    expect(expense.body.data.version).toBe(1);
    expect(
      expense.body.data.splits.reduce(
        (sum: number, split: { amountMinor: number }) => sum + split.amountMinor,
        0,
      ),
    ).toBe(1000);

    const balances = await request(server())
      .get(`/v1/trips/${tripId}/balances`)
      .set(auth(ownerToken))
      .expect(200);
    const byMember = new Map<string, number>(
      balances.body.data.balances.map((entry: { memberId: string; netMinor: number }) => [
        entry.memberId,
        entry.netMinor,
      ]),
    );
    expect(byMember.get(ownerMemberId)).toBe(500);
    expect(byMember.get(guestMemberId)).toBe(-500);

    const changes = await request(server())
      .get(`/v1/trips/${tripId}/changes?after=0`)
      .set(auth(ownerToken))
      .expect(200);
    const changeTypes = changes.body.data.changes.map(
      (change: { eventType: string }) => change.eventType,
    );
    expect(changeTypes).toContain('trip.created');
    expect(changeTypes).toContain('expense.created');

    const userSnapshot = await request(server())
      .get('/v1/users/me/snapshot')
      .set(auth(ownerToken))
      .expect(200);
    expect(
      userSnapshot.body.data.trips.map((trip: { id: string }) => trip.id),
    ).toContain(tripId);

    // Optimistic concurrency: missing and stale preconditions are rejected.
    await request(server())
      .patch(`/v1/trips/${tripId}/expenses/${expenseId}`)
      .set(auth(ownerToken))
      .set('Idempotency-Key', randomUUID())
      .send({ title: 'Dinner (updated)' })
      .expect(428);

    await request(server())
      .patch(`/v1/trips/${tripId}/expenses/${expenseId}`)
      .set(auth(ownerToken))
      .set('Idempotency-Key', randomUUID())
      .set('If-Match', '"999"')
      .send({ title: 'Dinner (updated)' })
      .expect(409);

    const updated = await request(server())
      .patch(`/v1/trips/${tripId}/expenses/${expenseId}`)
      .set(auth(ownerToken))
      .set('Idempotency-Key', randomUUID())
      .set('If-Match', '"1"')
      .send({ title: 'Dinner (updated)' })
      .expect(200);
    expect(updated.body.data.version).toBe(2);
    expect(updated.body.data.title).toBe('Dinner (updated)');
  });

  it('allows trip creation immediately after registration', async () => {
    const email = `fresh-${randomUUID()}@example.com`;
    const response = await request(server())
      .post('/v1/auth/register')
      .send({ name: 'Fresh', email, password: 'correct horse battery' })
      .expect(201);
    const token = response.body.data.accessToken as string;

    const created = await request(server())
      .post('/v1/trips')
      .set(auth(token))
      .set('Idempotency-Key', randomUUID())
      .send({ name: 'Immediate access' })
      .expect(201);
    expect(created.body.data.trip.name).toBe('Immediate access');
  });
});
