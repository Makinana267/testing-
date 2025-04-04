-- Create the database if it doesn't exist

BEGIN TRY
    -- Use master to check and create the database if not exists
    USE master;
    IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Autotest_IM_27March')
    BEGIN
        CREATE DATABASE Autotest_IM_27March;
    END
END TRY
BEGIN CATCH
    PRINT 'Error creating database: ' + ERROR_MESSAGE();
END CATCH
GO

BEGIN TRY
    -- Switch to the database
    USE Autotest_IM_27March;
END TRY
BEGIN CATCH
    PRINT 'Error switching to database: ' + ERROR_MESSAGE();
END CATCH
GO

BEGIN TRY
    -- Create the user table if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user')
    BEGIN
        CREATE TABLE [user] (
            Name NVARCHAR(50),
            Surname NVARCHAR(50),
            Email NVARCHAR(100)
        );
    END
END TRY
BEGIN CATCH
    PRINT 'Error creating table: ' + ERROR_MESSAGE();
END CATCH
GO
