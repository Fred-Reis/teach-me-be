import { CurrentUser } from '@/auth/current-user.decorator'
import { JwtAuthGuard } from '@/auth/jwt-auth.guard'
import { UserTokenSchema } from '@/auth/jwt.strategy'
import { ZodValidationPipe } from '@/pipes/zod-validation-pipe'
import { PrismaService } from '@/prisma/prisma.service'
import {
  Body,
  Controller,
  Post,
  UnauthorizedException,
  UseGuards,
  UsePipes,
} from '@nestjs/common'
import { z } from 'zod'

const createSpotBodySchema = z.object({
  date: z.string().datetime(),
  isAvailable: z.boolean().default(true),
})

type CreateSpotBodySchema = z.infer<typeof createSpotBodySchema>

@Controller('/spots')
@UseGuards(JwtAuthGuard)
export class CreateSpotsController {
  constructor(private prisma: PrismaService) {}

  @Post()
  @UsePipes(new ZodValidationPipe(createSpotBodySchema))
  async handle(
    @CurrentUser() user: UserTokenSchema,
    @Body() body: CreateSpotBodySchema,
  ) {
    const isTeacher = await this.prisma.user.findUnique({
      where: {
        id: user.sub,
        role: 'TEACHER',
      },
    })

    if (!isTeacher) {
      throw new UnauthorizedException('Only teachers can create a spot')
    }

    const isDateInTheFuture = new Date(body.date) > new Date()

    if (!isDateInTheFuture) {
      throw new UnauthorizedException('Date must be in the future')
    }

    await this.prisma.spot.create({
      data: {
        isAvailable: body.isAvailable,
        dateTime: body.date,
        teacherId: user.sub,
      },
    })
  }
}
