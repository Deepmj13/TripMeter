import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { ClientSession, Model } from 'mongoose';
import { AppError } from '../common/errors/app-error';
import { MEMBER_ROLES, MemberRole } from '../common/constants';
import { Trip, TripDocument } from '../database/schemas/trip.schema';
import { TripMember, TripMemberDocument } from '../database/schemas/trip-member.schema';

export interface TripAccess {
  trip: TripDocument;
  member: TripMemberDocument;
}

@Injectable()
export class TripAccessService {
  constructor(
    @InjectModel(Trip.name) private readonly tripModel: Model<TripDocument>,
    @InjectModel(TripMember.name) private readonly memberModel: Model<TripMemberDocument>,
  ) {}

  async requireMembership(
    tripId: string,
    userId: string,
    session?: ClientSession,
  ): Promise<TripAccess> {
    const tripQuery = this.tripModel.findOne({ _id: tripId });
    if (session) tripQuery.session(session);
    const trip = await tripQuery.exec();

    if (!trip) {
      throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');
    }

    const memberQuery = this.memberModel.findOne({ tripId, userId, status: 'active' });
    if (session) memberQuery.session(session);
    const member = await memberQuery.exec();

    if (!member) {
      // Do not reveal whether the trip exists to a non-member.
      throw AppError.notFound('TRIP_NOT_FOUND', 'Trip not found');
    }

    return { trip, member };
  }

  requireRole(member: TripMemberDocument, roles: MemberRole[]): void {
    if (!roles.includes(member.role)) {
      throw AppError.forbidden();
    }
  }

  assertWritable(trip: TripDocument): void {
    if (trip.archivedAt) {
      throw AppError.conflict('TRIP_ARCHIVED', 'This trip is archived and read-only');
    }
  }

  isOwner(member: TripMemberDocument): boolean {
    return member.role === MEMBER_ROLES[0];
  }

  async memberMap(
    tripId: string,
    session?: ClientSession,
  ): Promise<Map<string, TripMemberDocument>> {
    const query = this.memberModel.find({ tripId });
    if (session) query.session(session);
    const members = await query.exec();
    return new Map(members.map((member) => [member._id, member]));
  }
}
