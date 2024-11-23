/*
  Warnings:

  - You are about to drop the column `appointmentId` on the `schedule` table. All the data in the column will be lost.
  - You are about to drop the column `studentId` on the `schedule` table. All the data in the column will be lost.
  - You are about to drop the column `teacherId` on the `schedule` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[appointment_id]` on the table `schedule` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `appointment_id` to the `schedule` table without a default value. This is not possible if the table is not empty.
  - Made the column `is_available` on table `schedule` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_appointmentId_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_studentId_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_teacherId_fkey";

-- AlterTable
ALTER TABLE "schedule" DROP COLUMN "appointmentId",
DROP COLUMN "studentId",
DROP COLUMN "teacherId",
ADD COLUMN     "appointment_id" TEXT NOT NULL,
ADD COLUMN     "student_id" TEXT,
ADD COLUMN     "teacher_id" TEXT,
ALTER COLUMN "is_available" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "schedule_appointment_id_key" ON "schedule"("appointment_id");

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "student"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "teacher"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "appointment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
