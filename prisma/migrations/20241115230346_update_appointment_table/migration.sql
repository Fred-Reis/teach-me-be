/*
  Warnings:

  - Added the required column `duration` to the `appointment` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "appointment" ADD COLUMN     "duration" TEXT NOT NULL;
