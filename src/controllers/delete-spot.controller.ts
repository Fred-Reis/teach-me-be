import { CurrentUser } from '@/auth/current-user.decorator'
import { JwtAuthGuard } from '@/auth/jwt-auth.guard'
import { UserTokenSchema } from '@/auth/jwt.strategy'
import { PrismaService } from '@/prisma/prisma.service'
import {
  Controller,
  Delete,
  NotFoundException,
  Param,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common'

@Controller('/spots')
@UseGuards(JwtAuthGuard)
export class DeleteSpotController {
  constructor(private prisma: PrismaService) {}

  @Delete('/:id')
  async handle(@CurrentUser() user: UserTokenSchema, @Param('id') id: string) {
    const spot = await this.prisma.spot.findUnique({
      where: {
        id,
      },
    })

    if (!spot) {
      throw new NotFoundException('Spot not found')
    }

    if (spot.teacherId !== user.sub) {
      throw new UnauthorizedException('You are not allowed to delete this spot')
    }

    if (spot.appointmentId) {
      await this.prisma.appointment.delete({
        where: {
          id: spot.appointmentId,
        },
      })
    }

    await this.prisma.spot.delete({
      where: {
        id,
      },
    })
  }
}
