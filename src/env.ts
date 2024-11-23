import { z } from 'zod'

export const envSchema = z.object({
  NODE_ENV: z.enum(['dev', 'test', 'production']).default('dev'),
  DATABASE_URL: z.string(),
  JWT_PUBLIC_KEY: z.string(),
  JWT_PRIVATE_KEY: z.string(),
  DIRECT_URL: z.string().optional(),
  PORT: z.coerce.number().default(3333),
})

export type Env = z.infer<typeof envSchema>
