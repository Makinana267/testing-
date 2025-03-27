-- Create the database if it doesn't exist
USE master
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Autotest_IM_27March')
BEGIN
    CREATE DATABASE Autotest_IM_27March;
END
GO

-- Switch to the database
USE Autotest_IM_27March;
GO

-- Create the user table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user')
BEGIN
    CREATE TABLE [user] (
        Name NVARCHAR(50),
        Surname NVARCHAR(50),
        Email NVARCHAR(100)
    );
END
GO
