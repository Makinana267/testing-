DECLARE @execution_id BIGINT;
EXEC [SSISDB].[catalog].[create_execution] @package_name=N'Package.dtsx', @execution_id=@execution_id OUTPUT, @folder_name=N'Iviwe', @project_name=N'ProjectSecondForLeave', @use32bitruntime=0, @reference_id=NULL, @runinscaleout=0;
DECLARE @var0 SMALLINT = 1;
EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id, 50, N'LOGGING_LEVEL', @var0;
EXEC [SSISDB].[catalog].[start_execution] @execution_id;
