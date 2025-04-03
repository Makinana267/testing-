USE AutoTest_IviweMakinana;
GO

-- Create a stored procedure to insert data into the user table with TRY-CATCH
IF OBJECT_ID('usp_InsertUser', 'P') IS NOT NULL
    DROP PROCEDURE usp_InsertUser;
GO

CREATE PROCEDURE usp_InsertUser
    @Name NVARCHAR(50),
    @Surname NVARCHAR(50),
    @Email NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        -- Attempt to insert the data into the user table
        INSERT INTO [user] (Name, Surname, Email)
        VALUES (@Name, @Surname, @Email);

        -- If successful, print a success message (optional)
        PRINT 'User ' + @Name + ' ' + @Surname + ' inserted successfully.';
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the insert
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        -- Return the error details
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

-- Execute the stored procedure to insert sample data
BEGIN TRY
    EXEC usp_InsertUser @Name = 'John', @Surname = 'Doe', @Email = 'john.doe@example.com';
    EXEC usp_InsertUser @Name = 'Jane', @Surname = 'Smith', @Email = 'jane.smith@example.com';
END TRY
BEGIN CATCH
    -- Catch errors from the EXEC calls
    PRINT 'Error occurred while executing usp_InsertUser: ' + ERROR_MESSAGE();
END CATCH;
GO
