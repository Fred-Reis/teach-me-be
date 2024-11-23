-- DropForeignKey
ALTER TABLE "spot" DROP CONSTRAINT "spot_appointment_id_fkey";

-- DropForeignKey
ALTER TABLE "spot" DROP CONSTRAINT "spot_student_id_fkey";

-- AlterTable
ALTER TABLE "spot" ALTER COLUMN "student_id" DROP NOT NULL,
ALTER COLUMN "appointment_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spot" ADD CONSTRAINT "spot_appointment_id_fkey" FOREIGN KEY ("appointment_id") REFERENCES "appointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
