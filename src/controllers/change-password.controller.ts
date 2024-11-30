import { CurrentUser } from '@/auth/current-user.decorator'
import { JwtAuthGuard } from '@/auth/jwt-auth.guard'
import { UserTokenSchema } from '@/auth/jwt.strategy'
import { ZodValidationPipe } from '@/pipes/zod-validation-pipe'
import { PrismaService } from '@/prisma/prisma.service'
import {
  Body,
  Controller,
  NotFoundException,
  Patch,
  UnauthorizedException,
  UseGuards,
  UsePipes,
} from '@nestjs/common'
import { compare, hash } from 'bcryptjs'

import { z } from 'zod'

const changePasswordBodySchema = z.object({
  oldPassword: z.string().min(6),
  newPassword: z.string().min(6),
})

type ChangePasswordBodySchema = z.infer<typeof changePasswordBodySchema>

@Controller('/change-password')
@UseGuards(JwtAuthGuard)
@UsePipes(new ZodValidationPipe(changePasswordBodySchema))
export class ChangePasswordController {
  constructor(private prisma: PrismaService) {}

  @Patch()
  async handle(
    @CurrentUser() currentUser: UserTokenSchema,
    @Body() body: ChangePasswordBodySchema,
  ) {
    const user = await this.prisma.user.findUnique({
      where: {
        id: currentUser.sub,
      },
    })

    if (!user) {
      throw new NotFoundException('User not found')
    }

    const passwordMatch = await compare(body.oldPassword, user.password)

    if (!passwordMatch) {
      throw new UnauthorizedException('Invalid credentials')
    }

    const hashedNewPassword = await hash(body.newPassword, 8)

    await this.prisma.user.update({
      where: {
        id: currentUser.sub,
      },
      data: {
        password: hashedNewPassword,
      },
    })
  }
}
