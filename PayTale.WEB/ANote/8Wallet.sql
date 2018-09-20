
drop table wallet
Create Table Wallet
(
  Id bigint identity,
  GroupId bigint,
  GTranCode varchar(max),--STARTDATE+TOKEN
  MemberId bigint,
  WalletAmount decimal, --MAdvance
  AmtType varchar(max),--Advance/Settlement
  AddedDate datetime DEFAULT GETDATE(),
  ChangeDate datetime ,
  PayMaster varchar(max)
)
Select b.MemberName,a.MAdvance,a.AddedDate from Wallet a inner join PayTaleUser b on a.MemberId=b.MemberId where GroupId=GroupId

Create proc sp_WalletAction
(@GroupId bigint,
  @GTranCode varchar(max),--STARTDATE+TOKEN
  @MemberId bigint,
  @WalletAmount decimal, --MAdvance
  @AmtType varchar(max),
  @Action varchar(max),-- ADD/
  @PayMaster varchar(max)
   )
as 
begin --Amount can be in Positive or Negative for Add/ChangeAmout withGTrancode
--if(@Action='ADD')
--BEGIN
Insert into Wallet (GroupId ,  GTranCode ,  MemberId ,  WalletAmount ,  AmtType ,  AddedDate  ,    PayMaster )
VALUES (@GroupId ,  @GTranCode ,  @MemberId ,  @WalletAmount ,  @AmtType ,  @AddedDate  ,    @PayMaster)
--END
--ELSE IF (@Action='CHANGE')
--BEGIN
--UPDATE Wallet SET WalletAmount= WHERE Id=
--(SELECT TOP 1 ID FROM Wallet WHERE GroupId=@GroupId , GTranCode= @GTranCode ,  MemberId=@MemberId ,  WalletAmount=@WalletAmount )
--END
end

drop proc sp_WalletBalancePlus
Create proc sp_WalletBalancePlus 
(@GroupId bigint)
as
begin
Declare @GroupAdvance decimal
Declare @GAMExPay decimal
Declare @GAMHand decimal
Declare @GABalance decimal
Declare @WalletBalance decimal

set @GroupAdvance=(Select Sum(WalletAmount) from Wallet where  GroupId=GroupId)
set @GAMHand=(Select Sum(Amount) from PayTales where  GroupId=GroupId and MTypeId=MTypeId and 
PayTaleDate between 
DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))

set @GABalance=@GAMHand-@GroupAdvance

if(@GABalance>0)
begin
set @GAMExPay=@GABalance
end
else
begin
set @GAMExPay=0
end

set @WalletBalance = @GroupAdvance- IIF ( @GAMExPay>0, @GroupAdvance, @GAMHand )  

select @GroupAdvance,@WalletBalance,@GAMHand,@GAMExPay

end