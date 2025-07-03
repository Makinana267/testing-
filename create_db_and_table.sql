-- Create Database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TimsheetDB')
BEGIN
    CREATE DATABASE TimsheetDB;
END
GO

USE TimsheetDB;
GO

-- Create Employee Table
IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL
    DROP TABLE dbo.Employee;
GO
CREATE TABLE Employee (
    ConsultantID INT IDENTITY(1,1) PRIMARY KEY,
    ConsultantName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NULL,
    CONSTRAINT UQ_ConsultantName UNIQUE (ConsultantName)
);
GO

-- Create Clients Table
IF OBJECT_ID('dbo.Clients', 'U') IS NOT NULL
    DROP TABLE dbo.Clients;
GO
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_ClientName UNIQUE (ClientName)
);
GO

-- Create Task Table
IF OBJECT_ID('dbo.Task', 'U') IS NOT NULL
    DROP TABLE dbo.Task;
GO
CREATE TABLE Task (
    TaskID INT IDENTITY(1,1) PRIMARY KEY,
    TaskName NVARCHAR(100) NOT NULL,
    CONSTRAINT UQ_TaskIDName UNIQUE (TaskName)
);
GO

-- Create Project Table
IF OBJECT_ID('dbo.Project', 'U') IS NOT NULL
    DROP TABLE dbo.Project;
GO
CREATE TABLE Project (
    ProjectID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    ProjectName NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Projects_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    CONSTRAINT UQ_ProjectName_ClientID UNIQUE (ClientID, ProjectName)
);
GO

-- Create Timesheet Table
IF OBJECT_ID('dbo.Timesheet', 'U') IS NOT NULL
    DROP TABLE dbo.Timesheet;
GO
CREATE TABLE Timesheet (
    TimesheetID BIGINT IDENTITY(1,1) PRIMARY KEY,
    ConsultantID INT NULL,
    TaskID INT NULL,
    EntryDate DATE NOT NULL,
    DayOfWeek NVARCHAR(10) NOT NULL,
    Description NVARCHAR(255),
    Billable BIT NOT NULL,
    Comments NVARCHAR(500) NULL,
    TotalHours DECIMAL(10,4) NOT NULL CHECK (TotalHours >= 0),
    StartTime DECIMAL(10,4) NULL,
    EndTime DECIMAL(10,4) NULL,
    CONSTRAINT FK_TimesheetEntries_Consultants FOREIGN KEY (ConsultantID) REFERENCES Employee(ConsultantID),
    CONSTRAINT FK_TimesheetEntries_Tasks FOREIGN KEY (TaskID) REFERENCES Task(TaskID),
    CONSTRAINT CHK_StartEndTime CHECK (EndTime > StartTime OR StartTime IS NULL OR EndTime IS NULL)
);
GO

-- Create LeaveRecords Table
IF OBJECT_ID('dbo.LeaveRecords', 'U') IS NOT NULL
    DROP TABLE dbo.LeaveRecords;
GO
CREATE TABLE LeaveRecords (
    LeaveID INT IDENTITY(1,1) PRIMARY KEY,
    ConsultantID INT NOT NULL,
    LeaveType NVARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    NumberOfDays DECIMAL(5,2) NOT NULL CHECK (NumberOfDays >= 0),
    ApprovalObtained BIT NULL,
    SickNote BIT NULL,
    AddressDuringLeave NVARCHAR(255) NULL,
    CONSTRAINT FK_LeaveRecords_Consultants FOREIGN KEY (ConsultantID) REFERENCES Employee(ConsultantID),
    CONSTRAINT CHK_LeaveDates CHECK (EndDate >= StartDate)
);
GO

-- Create AuditLog Table
IF OBJECT_ID('dbo.AuditLog', 'U') IS NOT NULL
    DROP TABLE dbo.AuditLog;
GO
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    MessageName NVARCHAR(50),
    TaskName NVARCHAR(50),
    TableName NVARCHAR(50),
    RowsLoaded INT,
    RunDate DATETIME,
    ExecutedBy NVARCHAR(100),
    EmployeeName NVARCHAR(100),
    SheetName NVARCHAR(255)
);
GO

-- Create StagingTimesheet Table
IF OBJECT_ID('dbo.StagingTimesheet', 'U') IS NOT NULL
    DROP TABLE dbo.StagingTimesheet;
GO
CREATE TABLE StagingTimesheet (
    TimesheetID BIGINT,
    ConsultantID INT NULL,
    ConsultantName NVARCHAR(100),
    TaskID INT NULL,
    TaskName NVARCHAR(100) NULL,
    EntryDate DATETIME2 NULL,
    DayOfWeek NVARCHAR(10) NULL,
    Description NVARCHAR(255) NULL,
    Billable BIT NULL,
    Comments NVARCHAR(500) NULL,
    TotalHours DECIMAL(10,4) NULL,
    StartTime DECIMAL(10,4) NULL,
    EndTime DECIMAL(10,4) NULL,
    BatchID INT NULL,
    ErrorFlag BIT DEFAULT 0,
    ErrorMessage NVARCHAR(1000) NULL
);
GO

-- Create Stage_LeaveRecords Table
IF OBJECT_ID('dbo.Stage_LeaveRecords', 'U') IS NOT NULL
    DROP TABLE dbo.Stage_LeaveRecords;
GO
CREATE TABLE Stage_LeaveRecords (
    StageLeaveID INT IDENTITY(1,1) PRIMARY KEY,
    ConsultantID INT NULL,
    LeaveType NVARCHAR(50) NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    NumberOfDays DECIMAL(5,2) NULL,
    ApprovalObtained BIT NULL,
    SickNote BIT NULL,
    AddressDuringLeave NVARCHAR(255) NULL,
    CONSTRAINT CHK_Stage_LeaveDates CHECK (StartDate IS NULL OR EndDate >= StartDate)
);
GO

-- Create ErrorLog Table
IF OBJECT_ID('dbo.ErrorLog', 'U') IS NOT NULL
    DROP TABLE dbo.ErrorLog;
GO
CREATE TABLE dbo.ErrorLog (
    ErrorLogID INT NOT NULL PRIMARY KEY,
    ErrorTimeUtc DATETIME2(7) NOT NULL,
    ComponentName NVARCHAR(100) NOT NULL,
    ErrorMessage NVARCHAR(MAX) NOT NULL
);
GO
