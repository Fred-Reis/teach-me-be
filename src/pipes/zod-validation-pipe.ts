import {
  PipeTransform,
  BadRequestException,
  ArgumentMetadata,
} from '@nestjs/common'
import { ZodError, ZodSchema } from 'zod'
import { fromZodError } from 'zod-validation-error'

export class ZodValidationPipe implements PipeTransform {
  constructor(private schema: ZodSchema) {}

  transform(value: unknown, metadata: ArgumentMetadata) {
    if (metadata.type === 'custom') {
      return value
    }

    try {
      const parsedValue = this.schema.parse(value)
      return parsedValue
    } catch (error) {
      if (error instanceof ZodError) {
        throw new BadRequestException({
          message: error.issues[0].message,
          statusCode: 400,
          error: fromZodError(error),
        })
      }
      throw new BadRequestException('Validation failed')
    }
  }
}
