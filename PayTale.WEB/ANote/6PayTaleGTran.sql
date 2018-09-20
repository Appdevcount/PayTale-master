DROP TABLE GTran

CREATE TABLE GTran (
	Id BIGINT identity
	,GroupId BIGINT
	,GTranCode VARCHAR(max)
	,
	--STARTDATE+TOKEN
	STATUS VARCHAR(max)
	,
	--Closed/Active
	StartDate DATETIME
	,EndDate DATETIME
	)

Create PROC sp_GTranAction (
	@GroupId BIGINT
	,@STATUS VARCHAR(max)
	--Closed/Active
	)
AS
BEGIN
	--SELECT convert(varchar, getdate(),111)+convert(varchar, getdate(),108)  --2018/09/2012:34:59
	--SELECT replace(convert(varchar, getdate(),111),'/','') +replace(convert(varchar, getdate(),108),':','')  --20180920123524
	DECLARE @GTranCode VARCHAR(max) = (
			SELECT replace(convert(VARCHAR, getdate(), 111), '/', '') + replace(convert(VARCHAR, getdate(), 108), ':', '')
			);

	IF (@STATUS = 'Started')
	BEGIN
		INSERT INTO GTran (
			GroupId
			,GTranCode
			,STATUS
			,StartDate
			)
		VALUES (
			@GroupId
			,@GTranCode
			,@STATUS
			,GETDATE()
			)
	END
	ELSE IF (@STATUS = 'Closed')
	BEGIN
		UPDATE GTran
		SET STATUS = @STATUS
			,EndDate = GETDATE()
		WHERE GroupId = @GroupId AND GTranCode = @GTranCode
	END
END
