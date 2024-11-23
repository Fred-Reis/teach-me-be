import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { PrismaService } from '@/prisma/prisma.service'
import { CreateAccountController } from './controllers/create-account.controller'
import { envSchema } from '@/env'
import { AuthModule } from '@/auth/auth.module'
import { AuthenticationController } from '@/controllers/authentication.controller'
import { CreateAppointmentController } from './controllers/create-appointment.controller'
import { CreateSpotsController } from './controllers/create-spot.controller'

@Module({
  imports: [
    ConfigModule.forRoot({
      validate: (env) => envSchema.parse(env),
      isGlobal: true,
    }),
    AuthModule,
  ],
  controllers: [
    CreateAccountController,
    AuthenticationController,
    CreateAppointmentController,
    CreateSpotsController,
  ],
  providers: [PrismaService],
})
export class AppModule {}
