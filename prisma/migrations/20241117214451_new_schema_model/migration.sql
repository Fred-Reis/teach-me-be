/*
  Warnings:

  - You are about to drop the `student` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `teacher` table. If the table is not empty, all the data it contains will be lost.
  - Made the column `student_id` on table `schedule` required. This step will fail if there are existing NULL values in that column.
  - Made the column `teacher_id` on table `schedule` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('STUDENT', 'TEACHER');

-- DropForeignKey
ALTER TABLE "appointment" DROP CONSTRAINT "appointment_student_id_fkey";

-- DropForeignKey
ALTER TABLE "appointment" DROP CONSTRAINT "appointment_teacher_id_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_student_id_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_teacher_id_fkey";

-- AlterTable
ALTER TABLE "schedule" ALTER COLUMN "student_id" SET NOT NULL,
ALTER COLUMN "teacher_id" SET NOT NULL;

-- DropTable
DROP TABLE "student";

-- DropTable
DROP TABLE "teacher";

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "tags" TEXT[],
    "role" "UserRole" NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- AddForeignKey
ALTER TABLE "appointment" ADD CONSTRAINT "appointment_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "appointment" ADD CONSTRAINT "appointment_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
