import { AppError } from '../errors/app-error';

export interface PageCursor {
  value: string;
  id: string;
}

export function encodeCursor(cursor: PageCursor): string {
  return Buffer.from(JSON.stringify(cursor), 'utf8').toString('base64url');
}

export function decodeCursor(encoded: string): PageCursor {
  try {
    const parsed = JSON.parse(Buffer.from(encoded, 'base64url').toString('utf8')) as PageCursor;
    if (typeof parsed.value !== 'string' || typeof parsed.id !== 'string') throw new Error('bad');
    return parsed;
  } catch {
    throw AppError.validation('The pagination cursor is invalid');
  }
}
