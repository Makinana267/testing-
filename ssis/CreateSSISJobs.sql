-- =========================
-- Execute Package.dtsx
-- =========================
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution]
    @package_name = N'Package.dtsx',
    @execution_id = @execution_id OUTPUT,
    @folder_name = N'Iviwe',
    @project_name = N'ProjectSecondForLeave',
    @use32bitruntime = 0,
    @reference_id = NULL,
    @runinscaleout = 0;

SELECT @execution_id AS ExecutionID;

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
    @execution_id = @execution_id,
    @object_type = 50,
    @parameter_name = N'LOGGING_LEVEL',
    @parameter_value = 1;

EXEC [SSISDB].[catalog].[start_execution] @execution_id;
GO


-- =========================
-- Execute Clients.dtsx
-- =========================
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution]
    @package_name = N'Clients.dtsx',
    @execution_id = @execution_id OUTPUT,
    @folder_name = N'Iviwe',
    @project_name = N'ProjectSecondForLeave',
    @use32bitruntime = 0,
    @reference_id = NULL,
    @runinscaleout = 0;

SELECT @execution_id AS ExecutionID;

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
    @execution_id = @execution_id,
    @object_type = 50,
    @parameter_name = N'LOGGING_LEVEL',
    @parameter_value = 1;

EXEC [SSISDB].[catalog].[start_execution] @execution_id;
GO


-- =========================
-- Execute TimesheetETL.dtsx
-- =========================
DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution]
    @package_name = N'TimesheetETL.dtsx',
    @execution_id = @execution_id OUTPUT,
    @folder_name = N'Iviwe',
    @project_name = N'ProjectSecondForLeave',
    @use32bitruntime = 0,
    @reference_id = NULL,
    @runinscaleout = 0;

SELECT @execution_id AS ExecutionID;

EXEC [SSISDB].[catalog].[set_execution_parameter_value]
    @execution_id = @execution_id,
    @object_type = 50,
    @parameter_name = N'LOGGING_LEVEL',
    @parameter_value = 1;

EXEC [SSISDB].[catalog].[start_execution] @execution_id;
GO
