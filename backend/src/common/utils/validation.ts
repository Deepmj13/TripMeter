import { randomUUID } from 'crypto';
import { AppError } from '../errors/app-error';

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const CALENDAR_DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;

export function newId(): string {
  return randomUUID();
}

export function assertUuid(value: unknown, field = 'id'): string {
  if (typeof value !== 'string' || !UUID_PATTERN.test(value)) {
    throw AppError.validation(`${field} must be a valid UUID`, { field });
  }
  return value;
}

export function isUuid(value: unknown): value is string {
  return typeof value === 'string' && UUID_PATTERN.test(value);
}

export function assertCalendarDate(value: unknown, field = 'date'): string {
  if (typeof value !== 'string' || !CALENDAR_DATE_PATTERN.test(value)) {
    throw AppError.validation(`${field} must be a calendar date in YYYY-MM-DD format`, { field });
  }
  const [year, month, day] = value.split('-').map(Number);
  const parsed = new Date(Date.UTC(year, month - 1, day));
  if (
    parsed.getUTCFullYear() !== year ||
    parsed.getUTCMonth() !== month - 1 ||
    parsed.getUTCDate() !== day
  ) {
    throw AppError.validation(`${field} is not a real calendar date`, { field });
  }
  return value;
}

export function normalizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

export function assertEmail(value: unknown): string {
  if (typeof value !== 'string' || value.length > 254) {
    throw AppError.validation('email must be a valid email address', { field: 'email' });
  }
  const normalized = normalizeEmail(value);
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalized)) {
    throw AppError.validation('email must be a valid email address', { field: 'email' });
  }
  return normalized;
}

export function assertNonEmptyString(value: unknown, field: string, maxLength: number): string {
  if (typeof value !== 'string' || value.trim().length === 0 || value.length > maxLength) {
    throw AppError.validation(`${field} must be a non-empty string of at most ${maxLength} characters`, {
      field,
    });
  }
  return value.trim();
}
