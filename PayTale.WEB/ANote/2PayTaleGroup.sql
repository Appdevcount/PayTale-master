DROP TABLE PayTaleGroup

CREATE TABLE PayTaleGroup (
	GroupId BIGINT identity
	,GName VARCHAR(max)
	,GType VARCHAR(max)
	,
	--Food,Trip
	GCreator VARCHAR(max)
	,GAuditor VARCHAR(max) --Auditor of the month/Cause
	,Active BIT
	,CreatedDate DATETIME DEFAULT getdate()
	)

CREATE PROC sp_PayTaleGroupAction (
	@GName VARCHAR(max)
	,@GType VARCHAR(max)
	,@GCreator VARCHAR(max)
	,@GAuditor VARCHAR(max) --Auditor of the month/Cause
	,@Action VARCHAR(max) = '' --NEW/DEACTIVATE/REACTIVATE/DELETE/UPDATE/GETALL
	)
AS
BEGIN
	DECLARE @StatusCode INT --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST	7 UPDATESUCCESS
	DECLARE @Description VARCHAR(max) --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST 7 UPDATESUCCESS

	IF (@Action = 'GETALL')
	BEGIN
		SELECT *
		FROM PayTaleGroup
		ORDER BY 1 ASC;

		RETURN
	END

	IF (@Action = 'NEW')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator = @GCreator
				)
		BEGIN
			INSERT INTO PayTaleGroup (
				GName
				,GType
				,GCreator
				,GAuditor
				,Active
				)
			VALUES (
				@GName
				,@GType
				,@GCreator
				,@GAuditor
				,1
				)

			SET @StatusCode = 1
			SET @Description = 'NEWSUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 5
			SET @Description = 'GROUPEXISTS'
		END
	END
	ELSE IF (@Action = 'DEACTIVATE')
	BEGIN
		UPDATE PayTaleGroup
		SET Active = 0
			,GName =@GName
			,GAuditor=@GAuditor
		WHERE GName = @GName AND GCreator = @GCreator

		SET @StatusCode = 2
		SET @Description = 'DEACTIVATESUCCESS'
	END
	ELSE IF (@Action = 'REACTIVATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator = @GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = 1
			WHERE GName = @GName AND GCreator = @GCreator

			SET @StatusCode = 3
			SET @Description = 'REACTIVATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'GROUPNOTEXIST'
		END
	END
	ELSE IF (@Action = 'DELETE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator = @GCreator
				)
		BEGIN
			DELETE
			FROM PayTaleGroup
			WHERE GName = @GName AND GCreator = @GCreator

			SET @StatusCode = 4
			SET @Description = 'DELETESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'GROUPNOTEXIST'
		END
	END
	ELSE IF (@Action = 'UPDATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator = @GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET 
				GName = @GName
			WHERE GName = @GName AND GCreator = @GCreator

			SET @StatusCode = 7
			SET @Description = 'UPDATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'GROUPNOTEXIST'
		END
	END

	SELECT @StatusCode
		,@Description
END
