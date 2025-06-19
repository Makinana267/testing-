USE msdb;
GO

-- Drop existing job if it exists
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'RunTimesheetETL')
    EXEC msdb.dbo.sp_delete_job @job_name = N'RunTimesheetETL';
GO

-- Create new job
DECLARE @jobId BINARY(16);
EXEC msdb.dbo.sp_add_job
    @job_name = N'RunTimesheetETL',
    @enabled = 1,
    @notify_level_eventlog = 0,
    @notify_level_email = 0,
    @notify_level_netsend = 0,
    @notify_level_page = 0,
    @delete_level = 0,
    @description = N'Executes the TimesheetETL SSIS package daily.',
    @category_name = N'[Uncategorized (Local)]',
    @owner_login_name = N'sa',
    @job_id = @jobId OUTPUT;

-- Add job step to execute SSIS package
EXEC msdb.dbo.sp_add_jobstep
    @job_id = @jobId,
    @step_name = N'Execute TimesheetETL Package',
    @step_id = 1,
    @cmdexec_success_code = 0,
    @on_success_action = 1, -- Quit with success
    @on_fail_action = 2, -- Quit with failure
    @retry_attempts = 0,
    @retry_interval = 0,
    @os_run_priority = 0,
    @subsystem = N'SSIS',
    @command = N'/ISSERVER "\"\SSISDB\TimesheetETL\TimesheetETL\LoadTimesheet.dtsx\"" /SERVER "\"$(SQLSERVER)\"" /ENVREFERENCE 1 /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"" 1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"" True',
    @database_name = N'master',
    @flags = 0;

-- Add job schedule (daily at 2 AM)
EXEC msdb.dbo.sp_add_jobschedule
    @job_id = @jobId,
    @name = N'DailySchedule',
    @enabled = 1,
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @freq_subday_type = 1,
    @freq_subday_interval = 0,
    @freq_relative_interval = 0,
    @freq_recurrence_factor = 0,
    @active_start_date = 20250619,
    @active_end_date = 99991231,
    @active_start_time = 20000, -- 2:00 AM
    @active_end_time = 0;

-- Associate job with server
EXEC msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)';
GO
