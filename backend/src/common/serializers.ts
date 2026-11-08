import { TripDocument } from '../database/schemas/trip.schema';
import { TripMemberDocument } from '../database/schemas/trip-member.schema';
import { ExpenseDocument } from '../database/schemas/expense.schema';
import { SettlementDocument } from '../database/schemas/settlement.schema';

type Loose = Record<string, unknown>;

function timestamps(entity: unknown): { createdAt?: Date; updatedAt?: Date } {
  const record = entity as Loose;
  return {
    createdAt: record.createdAt as Date | undefined,
    updatedAt: record.updatedAt as Date | undefined,
  };
}

export function tripSnapshot(trip: TripDocument): Record<string, unknown> {
  return {
    id: trip._id,
    name: trip.name,
    destination: trip.destination,
    description: trip.description,
    currency: trip.currency,
    currencyExponent: trip.currencyExponent,
    startDate: trip.startDate,
    endDate: trip.endDate,
    createdByUserId: trip.createdByUserId,
    ownerUserId: trip.ownerUserId,
    archivedAt: trip.archivedAt,
    ...timestamps(trip),
  };
}

/**
 * Member snapshots deliberately omit `emailNormalized`: it is privileged and
 * must never reach the trip change feed or ordinary members.
 */
export function memberSnapshot(member: TripMemberDocument): Record<string, unknown> {
  return {
    id: member._id,
    tripId: member.tripId,
    userId: member.userId,
    displayName: member.displayName,
    memberKind: member.memberKind,
    role: member.role,
    status: member.status,
    joinedAt: member.joinedAt,
    ...timestamps(member),
  };
}

export function expenseSnapshot(expense: ExpenseDocument): Record<string, unknown> {
  return {
    id: expense._id,
    tripId: expense.tripId,
    title: expense.title,
    amountMinor: expense.amountMinor,
    currency: expense.currency,
    paidByMemberId: expense.paidByMemberId,
    createdByUserId: expense.createdByUserId,
    updatedByUserId: expense.updatedByUserId,
    deletedByUserId: expense.deletedByUserId,
    splitType: expense.splitType,
    splits: expense.splits.map((split) => ({
      memberId: split.memberId,
      amountMinor: split.amountMinor,
    })),
    category: expense.category,
    expenseDate: expense.expenseDate,
    description: expense.description,
    status: expense.status,
    version: expense.version,
    clientCreatedAt: expense.clientCreatedAt,
    deletedAt: expense.deletedAt,
    ...timestamps(expense),
  };
}

export function settlementSnapshot(settlement: SettlementDocument): Record<string, unknown> {
  return {
    id: settlement._id,
    tripId: settlement.tripId,
    paidByMemberId: settlement.paidByMemberId,
    paidToMemberId: settlement.paidToMemberId,
    amountMinor: settlement.amountMinor,
    paymentDate: settlement.paymentDate,
    status: settlement.status,
    recordedByUserId: settlement.recordedByUserId,
    confirmedByUserId: settlement.confirmedByUserId,
    statusChangedByUserId: settlement.statusChangedByUserId,
    statusChangedAt: settlement.statusChangedAt,
    rejectionReason: settlement.rejectionReason,
    note: settlement.note,
    version: settlement.version,
    confirmedAt: settlement.confirmedAt,
    ...timestamps(settlement),
  };
}
