USE master;
GO

-- 1. Create new Login in SQL Server levvel
CREATE LOGIN MedVitalsUser WITH PASSWORD = 'YOUR_STRONG_PASSWORD', 
             DEFAULT_DATABASE = MedVitalsDB, 
             CHECK_EXPIRATION = OFF, 
             CHECK_POLICY = OFF;
GO

USE MedVitalsDB;
GO

-- 2. Chane the Login as a user in that DB
CREATE USER MedVitalsUser FOR LOGIN MedVitalsUser;
GO

-- 3. Give access to the user to read, write and modifyALTER ROLE db_datareader ADD MEMBER MedVitalsUser;
ALTER ROLE db_datawriter ADD MEMBER MedVitalsUser;
ALTER ROLE db_owner ADD MEMBER MedVitalsUser; -- EF Core Migrations ??? ?????????? ??? ???????????
GO

CREATE DATABASE MedVitalsDB;
GO

USE MedVitalsDB;
GO

-- 1. MASTER TENANTS TABLE (Branding & Theme Engine)
CREATE TABLE Tenants (
    TenantId INT PRIMARY KEY IDENTITY(1,1),
    TenantName VARCHAR(100) NOT NULL,
    TenantDomain VARCHAR(100) NOT NULL UNIQUE,
    LogoUrl VARCHAR(500) NOT NULL,
    PrimaryColor VARCHAR(10) DEFAULT '#2563EB' NOT NULL,
    SecondaryColor VARCHAR(10) DEFAULT '#16A34A' NOT NULL,
    FontStyle VARCHAR(50) DEFAULT 'sans-serif' NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NULL
);

-- 2. USERS TABLE (Scoped by Tenant)
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    Name VARCHAR(100) NOT NULL,
    Mobile VARCHAR(15) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    UserStatus VARCHAR(20) DEFAULT 'Active' NOT NULL, -- Active, Inactive, Blocked
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NULL,
    CONSTRAINT UQ_Tenant_Mobile UNIQUE (TenantId, Mobile)
);

-- 3. USER DETAILS TABLE (Includes Dependents & Medical Card Data)
CREATE TABLE UserDetails (
    UserDetailId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    PatientName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NULL,
    MobileNo VARCHAR(15) NULL,
    ParentUserId INT NULL FOREIGN KEY REFERENCES Users(UserId), -- Null for Self
    InsuranceProvider VARCHAR(150) NULL,
    InsuranceCardNumber VARCHAR(50) NULL,
    MedicalHistoryNotes TEXT NULL,
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NOT NULL
);

-- 4. USER ADDRESSES TABLE (Multiple Addresses per User)
CREATE TABLE UserAddresses (
    AddressId INT PRIMARY KEY IDENTITY(1,1),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    AddressLine1 VARCHAR(255) NOT NULL,
    AddressLine2 VARCHAR(255) NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    AddressType VARCHAR(20) DEFAULT 'Home' NOT NULL,
    IsDefault BIT DEFAULT 0 NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NOT NULL
);

-- 5. HEALTH SERVICES TABLE (Lab Tests per Tenant)
CREATE TABLE HealthServices (
    ServiceId INT PRIMARY KEY IDENTITY(1,1),
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    ServiceName VARCHAR(150) NOT NULL,
    Description TEXT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NOT NULL
);

-- 6. BOOKINGS TABLE (Core Transaction Table)
CREATE TABLE Bookings (
    BookingId INT PRIMARY KEY IDENTITY(1,1),
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    UserDetailId INT NOT NULL FOREIGN KEY REFERENCES UserDetails(UserDetailId),
    ServiceId INT NOT NULL FOREIGN KEY REFERENCES HealthServices(ServiceId),
    ScheduleDate DATE NOT NULL,
    TimeSlot VARCHAR(30) NOT NULL,
    VisitType VARCHAR(20) NOT NULL, -- Home Visit, Lab Walk-in
    BookingStatus VARCHAR(20) DEFAULT 'Pending' NOT NULL,
    AppliedAddress VARCHAR(500) NULL,
    InsuranceUsed VARCHAR(100) NULL,
    CreatedDate DATETIME DEFAULT GETDATE() NOT NULL,
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME DEFAULT GETDATE() NOT NULL,
    ModifiedBy INT NOT NULL
);