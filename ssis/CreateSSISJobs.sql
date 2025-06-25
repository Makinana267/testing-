-- =========================
-- Remove existing job if it exists
-- =========================
USE [msdb];
GO

IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'{jobName}')
BEGIN
    EXEC msdb.dbo.sp_delete_job 
        @job_name = N'{jobName}';
END
GO


-- =========================
-- Create SQL Agent Job: {jobName}
-- =========================
DECLARE @jobId BINARY(16);

EXEC msdb.dbo.sp_add_job 
    @job_name = N'{jobName}',
    @enabled = 1,
    @notify_level_eventlog = 2,
    @delete_level = 0,
    @description = N'Scheduled job to execute SSIS package {jobName} every 1 minute',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'{dbUser}', -- Replace with actual SQL login
    @job_id = @jobId OUTPUT;
GO


-- =========================
-- Add Job Step: Run SSIS Package
-- =========================
EXEC msdb.dbo.sp_add_jobstep 
    @job_name = N'{jobName}',
    @step_name = N'Run SSIS Package',
    @subsystem = N'SSIS',
    @command = N'/ISSERVER "\"\SSISDB\Iviwe\ProjectSecondForLeave\{jobName}\"" /SERVER "{dbServer}"',
    @database_name = N'master',
    @on_success_action = 1,
    @on_fail_action = 2;
GO


-- =========================
-- Add Job Schedule: Run every 1 minute
-- =========================
EXEC msdb.dbo.sp_add_jobschedule 
    @job_name = N'{jobName}',
    @name = N'RunEveryMinute',
    @enabled = 1,
    @freq_type = 4,           -- Daily
    @freq_interval = 1,       -- Every day
    @freq_subday_type = 4,    -- Minutes
    @freq_subday_interval = 1,-- Every 1 minute
    @active_start_time = 000000;
GO


-- =========================
-- Attach Job to Local Server
-- =========================
EXEC msdb.dbo.sp_add_jobserver 
    @job_name = N'{jobName}',
    @server_name = N'(LOCAL)';
GO
