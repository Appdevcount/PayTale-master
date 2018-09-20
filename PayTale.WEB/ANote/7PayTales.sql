op table PayTales
Create Table PayTales
(
  Id bigint identity,
  GroupId bigint,
  GTranCode varchar(max),--STARTDATE+TOKEN
  MemberId bigint,
  MTypeId bigint ,
  Amount decimal,
  Category varchar(max),
  Note varchar(max),
  BillSnap varchar(max),
  PayTaleDate datetime default getdate() ,
  PayMaster varchar(max),

)
drop proc sp_PayTalesAction
Create proc sp_PayTalesAction
(
@PayID BIGINT =0,
@GroupId bigint,
  @MemberId bigint,
  @MTypeId bigint ,
  @Amount decimal,
  @Category varchar(max),
  @Note varchar(max),
  @BillSnap varchar(max),
  @Action varchar(max),--ADD/UPDATE/DELETE/GETALL
  @PayMaster varchar(max),

)
as
begin
IF(@Action='GETALL')
BEGIN
SELECT * FROM PayTales WHERE GroupId =@GroupId AND   GTranCode=@GTranCode
END
ELSE IF(@Action='ADD')
BEGIN
Insert into PayTales(GroupId ,
  MemberId ,
  MTypeId  ,
  Amount ,
  Category ,
  Note ,
  BillSnap ,PayMaster )  values(@GroupId ,
  @MemberId ,
  @MTypeId  ,
  @Amount ,
  @Category ,
  @Note ,
  @BillSnap,@PayMaster ) 
END
ELSE IF(@Action='UPDATE')
BEGIN
UPDATE PayTales SET Amount=@Amount,NOTE=@Note,PayMaster=@PayMaster  WHERE  ID=@PayID
END
ELSE IF(@Action='DELETE')
BEGIN
DELETE FROM PayTales WHERE ID=@PayID
END

end

