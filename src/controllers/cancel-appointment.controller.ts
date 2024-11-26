import { CurrentUser } from '@/auth/current-user.decorator'
import { JwtAuthGuard } from '@/auth/jwt-auth.guard'
import { UserTokenSchema } from '@/auth/jwt.strategy'
import { PrismaService } from '@/prisma/prisma.service'
import {
  Controller,
  NotFoundException,
  Param,
  Patch,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common'

@Controller('/cancel-appointment')
@UseGuards(JwtAuthGuard)
export class CancelAppointmentController {
  constructor(private prisma: PrismaService) {}

  @Patch('/:id')
  async handle(@CurrentUser() user: UserTokenSchema, @Param('id') id: string) {
    const appointment = await this.prisma.appointment.findUnique({
      where: {
        id,
      },
    })

    if (!appointment) {
      throw new NotFoundException('Appointment not found')
    }

    if (![appointment.studentId, appointment.teacherId].includes(user.sub)) {
      throw new UnauthorizedException(
        'You are not allowed to cancel the appointment',
      )
    }

    await this.prisma.spot.update({
      where: {
        appointmentId: id,
      },
      data: {
        isAvailable: true,
        appointmentId: null,
      },
    })

    await this.prisma.appointment.delete({
      where: {
        id,
      },
    })
  }
}
