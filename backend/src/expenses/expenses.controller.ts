import {
  Body,
  Controller,
  Delete,
  Get,
  Headers,
  Param,
  Patch,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import { Response } from 'express';
import {
  AuthenticatedUser,
  CurrentUser,
  IdempotencyKey,
  RequiresVerifiedEmail,
} from '../common/decorators';
import {
  CreateExpenseDto,
  ListExpensesQueryDto,
  UpdateExpenseDto,
} from './dto/expenses.dto';
import { ExpensesService } from './expenses.service';

@Controller('trips/:tripId/expenses')
export class ExpensesController {
  constructor(private readonly expensesService: ExpensesService) {}

  @RequiresVerifiedEmail()
  @Post()
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Body() dto: CreateExpenseDto,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.expensesService.create(tripId, user.userId, dto, idempotencyKey);
  }

  @Get()
  list(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Query() query: ListExpensesQueryDto,
  ) {
    return this.expensesService.list(tripId, user.userId, query);
  }

  @Get(':expenseId')
  async get(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('expenseId') expenseId: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    const expense = await this.expensesService.get(tripId, expenseId, user.userId);
    response.setHeader('ETag', `"${(expense as { version: number }).version}"`);
    return expense;
  }

  @RequiresVerifiedEmail()
  @Patch(':expenseId')
  update(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('expenseId') expenseId: string,
    @Body() dto: UpdateExpenseDto,
    @Headers('if-match') ifMatch: string | undefined,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.expensesService.update(
      tripId,
      expenseId,
      user.userId,
      dto,
      ifMatch,
      idempotencyKey,
    );
  }

  @RequiresVerifiedEmail()
  @Delete(':expenseId')
  remove(
    @CurrentUser() user: AuthenticatedUser,
    @Param('tripId') tripId: string,
    @Param('expenseId') expenseId: string,
    @Headers('if-match') ifMatch: string | undefined,
    @IdempotencyKey() idempotencyKey?: string,
  ) {
    return this.expensesService.remove(
      tripId,
      expenseId,
      user.userId,
      ifMatch,
      idempotencyKey,
    );
  }
}
