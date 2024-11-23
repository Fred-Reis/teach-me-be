-- AlterTable
ALTER TABLE "appointment" ADD COLUMN     "concluded" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "student" ADD COLUMN     "tags" TEXT[];

-- AlterTable
ALTER TABLE "teacher" ADD COLUMN     "tags" TEXT[];

-- CreateTable
CREATE TABLE "schedule" (
    "id" TEXT NOT NULL,
    "dateTime" TIMESTAMP(3) NOT NULL,
    "is_booked" BOOLEAN NOT NULL DEFAULT false,
    "is_available" BOOLEAN DEFAULT true,
    "studentId" TEXT,
    "teacherId" TEXT,
    "appointmentId" TEXT,

    CONSTRAINT "schedule_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "student"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "teacher"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedule" ADD CONSTRAINT "schedule_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "appointment"("id") ON DELETE SET NULL ON UPDATE CASCADE;
