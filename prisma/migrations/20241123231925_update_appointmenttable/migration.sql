/*
  Warnings:

  - A unique constraint covering the columns `[url]` on the table `appointment` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "appointment_url_key" ON "appointment"("url");