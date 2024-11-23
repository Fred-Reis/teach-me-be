/*
  Warnings:

  - You are about to drop the `schedule` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_appointment_id_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_student_id_fkey";

-- DropForeignKey
ALTER TABLE "schedule" DROP CONSTRAINT "schedule_teacher_id_fkey";

-- AlterTable
ALTER TABLE "appointment" ADD COLUMN     "rating" TEXT,
ADD COLUMN     "subject" TEXT;

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "rating" TEXT;

-- DropTable
DROP TABLE "schedule";

-- CreateTable
CREATE TABLE "spot" (
    "id" TEXT NOT NULL,
    "dateTime" TIMESTAMP(3) NOT NULL,
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "student_id" TEXT NOT NULL,
    "teacher_id" TEXT NOT NULL,
    "appointment_id" TEXT NOT NULL,

    CONSTRAINT "spot_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "spot_appointment_id_key" ON "spot"("appointment_id");

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "appointment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
