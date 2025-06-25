USE [msdb]
GO

-- Check if job exists and delete it to avoid conflicts
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Run SSIS Packages Every 2 Minutes')
    EXEC msdb.dbo.sp_delete_job @job_name=N'Run SSIS Packages Every 2 Minutes', @delete_unused_schedule=1;
GO

-- Create Job
EXEC msdb.dbo.sp_add_job @job_name=N'Run SSIS Packages Every 2 Minutes', 
    @enabled=0,  -- Disabled to avoid immediate scheduling
    @description=N'Runs SSIS packages (Package.dtsx, Clients.dtsx, TimesheetETL.dtsx)';

-- Add Job Step for Package.dtsx
EXEC msdb.dbo.sp_add_jobstep 
    @job_name=N'Run SSIS Packages Every 2 Minutes', 
    @step_name=N'Execute Package.dtsx', 
    @subsystem=N'TSQL', 
    @command=N'
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution] @package_name=N''Package.dtsx'', @execution_id=@execution_id OUTPUT, @folder_name=N''Iviwe'', @project_name=N''ProjectSecondForLeave'', @use32bitruntime=0, @reference_id=NULL, @runinscaleout=0;
DECLARE @var0 SMALLINT = 1;
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id, 50, N''LOGGING_LEVEL'', @var0;
EXEC [SSISDB].[catalog].[start_execution] @execution_id;
', 
    @database_name=N'SSISDB', 
    @on_success_action=3;

-- Add Job Step for Clients.dtsx
EXEC msdb.dbo.sp_add_jobstep 
    @job_name=N'Run SSIS Packages Every 2 Minutes', 
    @step_name=N'Execute Clients.dtsx', 
    @subsystem=N'TSQL', 
    @command=N'
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution] @package_name=N''Clients.dtsx'', @execution_id=@execution_id OUTPUT, @folder_name=N''Iviwe'', @project_name=N''ProjectSecondForLeave'', @use32bitruntime=0, @reference_id=NULL, @runinscaleout=0;
DECLARE @var0 SMALLINT = 1;
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id, 50, N''LOGGING_LEVEL'', @var0;
EXEC [SSISDB].[catalog].[start_execution] @execution_id;
', 
    @database_name=N'SSISDB', 
    @on_success_action=3;

-- Add Job Step for TimesheetETL.dtsx
EXEC msdb.dbo.sp_add_jobstep 
    @job_name=N'Run SSIS Packages Every 2 Minutes', 
    @step_name=N'Execute TimesheetETL.dtsx', 
    @subsystem=N'TSQL', 
    @command=N'
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution] @package_name=N''TimesheetETL.dtsx'', @execution_id=@execution_id OUTPUT, @folder_name=N''Iviwe'', @project_name=N''ProjectSecondForLeave'', @use32bitruntime=0, @reference_id=NULL, @runinscaleout=0;
DECLARE @var0 SMALLINT = 1;
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id, 50, N''LOGGING_LEVEL'', @var0;
EXEC [SSISDB].[catalog].[start_execution] @execution_id;
', 
    @database_name=N'SSISDB', 
    @on_success_action=1;

-- Assign Job to Server
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Run SSIS Packages Every 2 Minutes', @server_name=@@SERVERNAME;
GO
