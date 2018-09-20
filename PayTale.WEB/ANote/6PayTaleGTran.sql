
DROP TABLE PayTaleGTran

CREATE TABLE PayTaleGTran (
	Id BIGINT identity, 
	GroupId BIGINT, 
	GTranCode VARCHAR(max),
	--STARTDATE+TOKEN
	STATUS VARCHAR(max),
	--Closed/Active
	StartDate DATETIME, 
	EndDate DATETIME
	)
	

Create proc sp_PayTaleGTranAction
(@GroupId BIGINT, 
	@STATUS VARCHAR(max)
	--Closed/Active
	)
as
begin
--SELECT convert(varchar, getdate(),111)+convert(varchar, getdate(),108)  --2018/09/2012:34:59
--SELECT replace(convert(varchar, getdate(),111),'/','') +replace(convert(varchar, getdate(),108),':','')  --20180920123524
Declare @GTranCode VARCHAR(max)=(SELECT replace(convert(varchar, getdate(),111),'/','') +replace(convert(varchar, getdate(),108),':',''));

if(@STATUS='Started')
begin
INSERT INTO PayTaleGTran(GroupId,GTranCode,STATUS,StartDate) VALUES(@GroupId,@GTranCode,@STATUS,GETDATE())
end
else if(@STATUS='Closed')
begin
UPDATE PayTaleGTran SET STATUS=@STATUS,EndDate=GETDATE() WHERE GroupId=@GroupId and GTranCode=@GTranCode
end
end


