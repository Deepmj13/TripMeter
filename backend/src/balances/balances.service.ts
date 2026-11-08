import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { AppError } from '../common/errors/app-error';
import { Expense, ExpenseDocument } from '../database/schemas/expense.schema';
import { Settlement, SettlementDocument } from '../database/schemas/settlement.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';
import { TripAccessService } from '../trips/trip-access.service';
import {
  applyPendingReservations,
  computeBalances,
  isBalanced,
  suggestTransfers,
} from './balance-engine';

@Injectable()
export class BalancesService {
  private readonly logger = new Logger(BalancesService.name);

  constructor(
    @InjectModel(Expense.name) private readonly expenseModel: Model<ExpenseDocument>,
    @InjectModel(Settlement.name) private readonly settlementModel: Model<SettlementDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
    private readonly access: TripAccessService,
  ) {}

  async balances(tripId: string, userId: string) {
    const { trip } = await this.access.requireMembership(tripId, userId);
    const { expenses, settlements } = await this.loadFinancialData(tripId);

    const map = computeBalances(expenses, settlements);
    if (!isBalanced(map)) {
      this.logger.error(`Balance integrity check failed for trip ${tripId}`);
      throw new AppError(
        'INTERNAL_ERROR',
        'Balance integrity check failed for this trip',
        500,
      );
    }

    const members = await this.memberModel.find({ tripId }).lean().exec();
    const nameOf = new Map(members.map((member) => [member._id, member.displayName]));

    return {
      tripId,
      currency: trip.currency,
      currencyExponent: trip.currencyExponent,
      provisional: false,
      balances: [...map.entries()]
        .map(([memberId, netMinor]) => ({
          memberId,
          displayName: nameOf.get(memberId) ?? 'Unknown',
          netMinor,
        }))
        .sort((a, b) => b.netMinor - a.netMinor || a.memberId.localeCompare(b.memberId)),
    };
  }

  async settlementSuggestions(tripId: string, userId: string) {
    const { trip } = await this.access.requireMembership(tripId, userId);
    const expenses = await this.loadExpenses(tripId);
    const confirmed = await this.loadSettlements(tripId, 'confirmed');
    const pending = await this.loadSettlements(tripId, 'pending');

    const confirmedBalances = computeBalances(expenses, confirmed);
    if (!isBalanced(confirmedBalances)) {
      this.logger.error(`Balance integrity check failed for trip ${tripId}`);
      throw new AppError(
        'INTERNAL_ERROR',
        'Balance integrity check failed for this trip',
        500,
      );
    }

    const { remaining, reservations } = applyPendingReservations(
      confirmedBalances,
      pending,
    );
    const suggestions = suggestTransfers(remaining);

    return {
      tripId,
      currency: trip.currency,
      currencyExponent: trip.currencyExponent,
      suggestions,
      pendingReservations: reservations,
    };
  }

  private async loadFinancialData(tripId: string) {
    const [expenses, settlements] = await Promise.all([
      this.loadExpenses(tripId),
      this.loadSettlements(tripId, 'confirmed'),
    ]);
    return { expenses, settlements };
  }

  private async loadExpenses(tripId: string) {
    const expenses = await this.expenseModel
      .find({ tripId, status: 'active' })
      .lean()
      .exec();
    return expenses.map((expense) => ({
      paidByMemberId: expense.paidByMemberId,
      amountMinor: expense.amountMinor,
      splits: expense.splits.map((split) => ({
        memberId: split.memberId,
        amountMinor: split.amountMinor,
      })),
    }));
  }

  private async loadSettlements(tripId: string, status: 'confirmed' | 'pending') {
    const settlements = await this.settlementModel
      .find({ tripId, status })
      .lean()
      .exec();
    return settlements.map((settlement) => ({
      _id: settlement._id,
      paidByMemberId: settlement.paidByMemberId,
      paidToMemberId: settlement.paidToMemberId,
      amountMinor: settlement.amountMinor,
      status: settlement.status as 'confirmed' | 'pending',
    }));
  }
}
