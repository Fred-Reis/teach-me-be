import { CurrentUser } from '@/auth/current-user.decorator'
import { JwtAuthGuard } from '@/auth/jwt-auth.guard'
import { UserTokenSchema } from '@/auth/jwt.strategy'
import { ZodValidationPipe } from '@/pipes/zod-validation-pipe'
import { PrismaService } from '@/prisma/prisma.service'
import {
  Body,
  Controller,
  NotFoundException,
  Post,
  UnauthorizedException,
  UseGuards,
  UsePipes,
} from '@nestjs/common'
import { z } from 'zod'

const createAppointmentBodySchema = z.object({
  spotId: z.string().uuid(),
  subject: z.string().optional(),
  duration: z.string().default('60'),
  rating: z.string().optional(),
})

type CreateAppointmentBodySchema = z.infer<typeof createAppointmentBodySchema>

@Controller('/appointments')
@UseGuards(JwtAuthGuard)
export class CreateAppointmentController {
  constructor(private prisma: PrismaService) {}

  @Post()
  @UsePipes(new ZodValidationPipe(createAppointmentBodySchema))
  async handle(
    @CurrentUser() user: UserTokenSchema,
    @Body() body: CreateAppointmentBodySchema,
  ) {
    const { spotId, subject, duration, rating } = body

    const spot = await this.prisma.spot.findUnique({
      where: {
        id: spotId,
      },
    })

    if (!spot) {
      throw new NotFoundException('Spot not found')
    }

    if (spot.isAvailable !== true) {
      throw new UnauthorizedException('This spot is not available')
    }

    const generateRandomUrl = `http://www.${Math.random().toString(36).slice(2)}.com`

    const appointment = await this.prisma.appointment.create({
      data: {
        date: spot.dateTime,
        duration,
        url: generateRandomUrl,
        subject,
        studentId: user.sub,
        teacherId: spot.teacherId,
        rating,
      },
    })

    await this.prisma.spot.update({
      where: {
        id: spotId,
      },
      data: {
        isAvailable: false,
        appointmentId: appointment.id,
      },
    })

    return appointment
  }
}
