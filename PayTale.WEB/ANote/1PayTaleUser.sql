DROP TABLE PayTaleUser

CREATE TABLE PayTaleUser (MemberId BIGINT identity, MemberName VARCHAR(max), UserEmail VARCHAR(max), Password VARCHAR(max), JoinedDate DATETIME DEFAULT getdate(), Active BIT, LeftDate DATETIME, ReJoinedDate DATETIME)

CREATE PROC sp_UserAction (
	@MemberName VARCHAR(max) = NULL, @UserEmail VARCHAR(max) = NULL, @Password VARCHAR(max) = NULL, @Active BIT = 0, @Action VARCHAR(max) = '' --NEW/DEACTIVATE/REACTIVATE/DELETE/UPDATEPWD/GETALL
	)
AS
BEGIN
	DECLARE @StatusCode INT --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST	7 UPDATEPWDSUCCESS
	DECLARE @Description VARCHAR(max) --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST 7 UPDATEPWDSUCCESS

	IF (@Action = 'GETALL')
	BEGIN
		SELECT *
		FROM PayTaleUser
		ORDER BY 1 ASC;

		RETURN
	END

	IF (@Action = 'NEW')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleUser
				WHERE UserEmail = @UserEmail
				)
		BEGIN
			INSERT INTO PayTaleUser (MemberName, UserEmail, Password, JoinedDate, Active)
			VALUES (@MemberName, @UserEmail, @Password, GETDATE(), 1)

			SET @StatusCode = 1
			SET @Description = 'NEWSUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 5
			SET @Description = 'USEREXISTS'
		END
	END
	ELSE IF (@Action = 'DEACTIVATE')
	BEGIN
		UPDATE PayTaleUser
		SET Active = 0, LeftDate = GETDATE()
		WHERE UserEmail = @UserEmail

		SET @StatusCode = 2
		SET @Description = 'DEACTIVATESUCCESS'
	END
	ELSE IF (@Action = 'REACTIVATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleUser
				WHERE UserEmail = @UserEmail
				)
		BEGIN
			UPDATE PayTaleUser
			SET Active = 1, ReJoinedDate = GETDATE()
			WHERE UserEmail = @UserEmail

			SET @StatusCode = 3
			SET @Description = 'REACTIVATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'USERNOTEXIST'
		END
	END
	ELSE IF (@Action = 'DELETE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleUser
				WHERE UserEmail = @UserEmail
				)
		BEGIN
			DELETE
			FROM PayTaleUser
			WHERE UserEmail = @UserEmail

			SET @StatusCode = 4
			SET @Description = 'DELETESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'USERNOTEXIST'
		END
	END
	ELSE IF (@Action = 'UPDATEPWD')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleUser
				WHERE UserEmail = @UserEmail
				)
		BEGIN
			UPDATE PayTaleUser
			SET PASSWORD = @PASSWORD
			WHERE UserEmail = @UserEmail

			SET @StatusCode = 7
			SET @Description = 'UPDATEPWDSUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'USERNOTEXIST'
		END
	END

	SELECT @StatusCode, @Description
END
