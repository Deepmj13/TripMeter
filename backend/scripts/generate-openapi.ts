import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { writeFileSync } from 'fs';
import { join } from 'path';
import { AppModule } from '../src/app.module';

/**
 * Generates the OpenAPI contract without opening an HTTP port. Uses the
 * `preview` mode so Nest builds the module graph but does not run lifecycle
 * hooks, which keeps the command independent of a running MongoDB instance.
 */
async function generate(): Promise<void> {
  const app = await NestFactory.create(AppModule, { preview: true, logger: false });

  const config = new DocumentBuilder()
    .setTitle('Trip Expense Manager API')
    .setDescription('Offline-first collaborative trip expense API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  const target = join(process.cwd(), 'openapi.json');
  writeFileSync(target, `${JSON.stringify(document, null, 2)}\n`, 'utf8');
  await app.close();
  // eslint-disable-next-line no-console
  console.log(`OpenAPI document written to ${target}`);
}

generate().catch((error: unknown) => {
  // eslint-disable-next-line no-console
  console.error(error);
  process.exit(1);
});
