-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" DATETIME,
    "image" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" DATETIME NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Authenticator" (
    "credentialID" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "credentialPublicKey" TEXT NOT NULL,
    "counter" INTEGER NOT NULL,
    "credentialDeviceType" TEXT NOT NULL,
    "credentialBackedUp" BOOLEAN NOT NULL,
    "transports" TEXT,

    PRIMARY KEY ("userId", "credentialID"),
    CONSTRAINT "Authenticator_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Address" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "street" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "district" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Contacts" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "telephone" INTEGER,
    "email" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Person" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "addressId" INTEGER NOT NULL,
    "ContactsId" INTEGER NOT NULL,
    CONSTRAINT "Person_ContactsId_fkey" FOREIGN KEY ("ContactsId") REFERENCES "Contacts" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Person_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES "Address" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Event" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "image" TEXT,
    "payment" BOOLEAN NOT NULL,
    "price" DECIMAL NOT NULL,
    "description" TEXT NOT NULL,
    "publishedById" TEXT NOT NULL,
    CONSTRAINT "Event_publishedById_fkey" FOREIGN KEY ("publishedById") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "RegistrationToken" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "token" TEXT NOT NULL,
    "expired_at" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Registration" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "EventId" INTEGER NOT NULL,
    "personId" INTEGER NOT NULL,
    "tokenId" INTEGER NOT NULL,
    CONSTRAINT "Registration_tokenId_fkey" FOREIGN KEY ("tokenId") REFERENCES "RegistrationToken" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Registration_personId_fkey" FOREIGN KEY ("personId") REFERENCES "Person" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Registration_EventId_fkey" FOREIGN KEY ("EventId") REFERENCES "Event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "paymentStatus" TEXT NOT NULL DEFAULT 'PENDENTE',
    "RegistrationId" INTEGER NOT NULL,
    CONSTRAINT "Payment_RegistrationId_fkey" FOREIGN KEY ("RegistrationId") REFERENCES "Registration" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- CreateIndex
CREATE UNIQUE INDEX "Authenticator_credentialID_key" ON "Authenticator"("credentialID");

-- CreateIndex
CREATE UNIQUE INDEX "Person_addressId_key" ON "Person"("addressId");

-- CreateIndex
CREATE UNIQUE INDEX "Person_ContactsId_key" ON "Person"("ContactsId");

-- CreateIndex
CREATE UNIQUE INDEX "Registration_tokenId_key" ON "Registration"("tokenId");
