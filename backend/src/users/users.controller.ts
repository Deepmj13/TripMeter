import { Body, Controller, Delete, Get, Param, Patch } from '@nestjs/common';
import { CurrentUser, AuthenticatedUser } from '../common/decorators';
import { DeleteAccountDto, UpdateProfileDto } from './dto/users.dto';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  me(@CurrentUser() user: AuthenticatedUser) {
    return this.usersService.me(user.userId);
  }

  @Patch('me')
  updateMe(@CurrentUser() user: AuthenticatedUser, @Body() dto: UpdateProfileDto) {
    return this.usersService.updateProfile(user.userId, dto);
  }

  @Get('me/sessions')
  sessions(@CurrentUser() user: AuthenticatedUser) {
    return this.usersService.sessions(user.userId);
  }

  @Delete('me/sessions/:sessionId')
  revokeSession(
    @CurrentUser() user: AuthenticatedUser,
    @Param('sessionId') sessionId: string,
  ) {
    return this.usersService.revokeSession(user.userId, sessionId);
  }

  @Delete('me')
  deleteAccount(@CurrentUser() user: AuthenticatedUser, @Body() dto: DeleteAccountDto) {
    return this.usersService.deleteAccount(user.userId, dto);
  }
}
