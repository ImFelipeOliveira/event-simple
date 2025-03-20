/*
  Warnings:

  - You are about to drop the column `payment` on the `Event` table. All the data in the column will be lost.
  - You are about to drop the column `expired_at` on the `RegistrationToken` table. All the data in the column will be lost.
  - Added the required column `addressId` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `endDate` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `maxParticipants` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `registrationDeadline` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `requiresPayment` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `startDate` to the `Event` table without a default value. This is not possible if the table is not empty.
  - Added the required column `expiredAt` to the `RegistrationToken` table without a default value. This is not possible if the table is not empty.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Event" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "image" TEXT,
    "requiresPayment" BOOLEAN NOT NULL,
    "price" DECIMAL NOT NULL,
    "maxParticipants" INTEGER NOT NULL,
    "description" TEXT NOT NULL,
    "startDate" DATETIME NOT NULL,
    "endDate" DATETIME NOT NULL,
    "registrationDeadline" DATETIME NOT NULL,
    "addressId" INTEGER NOT NULL,
    "publishedById" TEXT NOT NULL,
    CONSTRAINT "Event_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES "Address" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Event_publishedById_fkey" FOREIGN KEY ("publishedById") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Event" ("description", "id", "image", "name", "price", "publishedById") SELECT "description", "id", "image", "name", "price", "publishedById" FROM "Event";
DROP TABLE "Event";
ALTER TABLE "new_Event" RENAME TO "Event";
CREATE TABLE "new_RegistrationToken" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "token" TEXT NOT NULL,
    "expiredAt" DATETIME NOT NULL
);
INSERT INTO "new_RegistrationToken" ("id", "token") SELECT "id", "token" FROM "RegistrationToken";
DROP TABLE "RegistrationToken";
ALTER TABLE "new_RegistrationToken" RENAME TO "RegistrationToken";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
