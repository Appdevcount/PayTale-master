DROP TABLE GMembers

CREATE TABLE GMembers (
	Id BIGINT identity, 
	GroupId BIGINT,
	 MemberId BIGINT, 
	 MemberName VARCHAR(max), 
	 GMemberType VARCHAR(max),
	-- Member/AOM/AOC/Auditor
	Active BIT
	)

CREATE PROC sp_GMembersAction (
	@GroupId BIGINT, @MemberId BIGINT, @MemberName VARCHAR(max), @GMemberType VARCHAR(max), @Active BIT, @Action VARCHAR(max) --NEW/DEACTIVATE/REACTIVATE/UPDATE/DELETE/GETALL
	)
AS
BEGIN
	DECLARE @StatusCode INT --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST	7 UPDATESUCCESS
	DECLARE @Description VARCHAR(max) --0 Failed 1 NEWSUCCESS 2 DEACTIVATESUCCESS 3 REACTIVATESUCCESS 4 DELETESUCCESS 5 USEREXISTS 6 USERNOTEXIST 7 UPDATESUCCESS

	IF (@Action = 'GETALL')
	BEGIN
		SELECT *
		FROM GMembers
		ORDER BY 1 ASC;

		RETURN
	END

	IF (@Action = 'NEW')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM GMembers
				WHERE GroupId = @GroupId AND MemberId = @MemberId
				)
		BEGIN
			INSERT INTO GMembers ( GroupId , MemberId , MemberName , GMemberType , Active  )
			VALUES (@GroupId , @MemberId , @MemberName , @GMemberType , 1 )

			SET @StatusCode = 1
			SET @Description = 'NEWSUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 5
			SET @Description = 'MEMBEREXISTS'
		END
	END
	ELSE IF (@Action = 'DEACTIVATE')
	BEGIN
		UPDATE GMembers
		SET Active = 0
		WHERE GName = @GName AND GCreator = @GCreator

		SET @StatusCode = 2
		SET @Description = 'DEACTIVATESUCCESS'
	END
	ELSE IF (@Action = 'REACTIVATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM GMembers
				WHERE GroupId = @GroupId AND MemberId = @MemberId
				)
		BEGIN
			UPDATE GMembers
			SET Active = 1
			WHERE GroupId = @GroupId AND MemberId = @MemberId

			SET @StatusCode = 3
			SET @Description = 'REACTIVATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'MEMBEREXISTS'
		END
	END
	ELSE IF (@Action = 'DELETE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM GMembers
				WHERE GroupId = @GroupId AND MemberId = @MemberId
				)
		BEGIN
			DELETE
			FROM GMembers
			WHERE GroupId = @GroupId AND MemberId = @MemberId

			SET @StatusCode = 4
			SET @Description = 'DELETESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'MEMBEREXISTS'
		END
	END
	ELSE IF (@Action = 'UPDATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM GMembers
				WHERE GroupId = @GroupId AND MemberId = @MemberId
				)
		BEGIN
			UPDATE GMembers
			SET Active = @Active, GName = @GName
			WHERE GroupId = @GroupId AND MemberId = @MemberId

			SET @StatusCode = 7
			SET @Description = 'UPDATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'MEMBEREXISTS'
		END
	END

	SELECT @StatusCode, @Description
END
