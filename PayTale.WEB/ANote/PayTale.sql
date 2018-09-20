--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--PayTale Version 1
--========
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

DROP TABLE PayTaleGroup

CREATE TABLE PayTaleGroup (
	GroupId BIGINT identity, GName VARCHAR(max), GType VARCHAR(max),
	--Food,Trip
	GCreator VARCHAR(max), GAuditor VARCHAR(max) --Auditor of the month/Cause
	, Active BIT,
	CreatedDate datetime default getdate()
	)

CREATE PROC sp_PayTaleGroupAction (
	@GName VARCHAR(max), @GType VARCHAR(max), @GCreator VARCHAR(max), @GAuditor VARCHAR(max) --Auditor of the month/Cause
	, @Action VARCHAR(max) = '' --NEW/DEACTIVATE/REACTIVATE/DELETE/UPDATE/GETALL
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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			INSERT INTO PayTaleGroup (GName, GType, GCreator, GAuditor, Active)
			VALUES (@GName, @GType, @GCreator, @GAuditor, 1)

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
		SET Active = 0, GName = GETDATE(), GAuditor
		WHERE GName = @GName and GCreator=@GCreator

		SET @StatusCode = 2
		SET @Description = 'DEACTIVATESUCCESS'
	END
	ELSE IF (@Action = 'REACTIVATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = 1
			WHERE GName = @GName AND GCreator=@GCreator

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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			DELETE
			FROM PayTaleGroup
			WHERE GName = @GName AND GCreator=@GCreator

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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = @Active, GName = @GName 
			WHERE GName = @GName AND GCreator=@GCreator

			SET @StatusCode = 7
			SET @Description = 'UPDATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'GROUPNOTEXIST'
		END
	END

	SELECT @StatusCode, @Description
END

DROP TABLE ExpenseCategory

CREATE TABLE ExpenseCategory (
	Id BIGINT identity, ExpCategory VARCHAR(max) --Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation
	)
	
Insert into ExpenseCategory(ExpCategory) values 
('Restuarant'),('HouseholdItems'),('CookingItems'),('Others'),('Automobile'),('Donation'),('Gifts'),('Entertainment'),('Transportation');


DROP TABLE MemberType

CREATE TABLE MemberType (
	MTypeId BIGINT identity, MType VARCHAR(max) -- Member/Auditor
	)
	
Insert into MemberType(MType) values 
('Member'),('Auditor');

DROP TABLE GMembers

CREATE TABLE GMembers (
	Id BIGINT identity, GroupId BIGINT, MemberId BIGINT, MemberName VARCHAR(max), GMemberType VARCHAR(max),
	-- Member/AOM/AOC/Auditor
	Active BIT
	)

Create proc sp_GMembersAction
( @GroupId BIGINT, @MemberId BIGINT, @MemberName VARCHAR(max), @GMemberType VARCHAR(max),
	@Active BIT,@Action VARCHAR(max)--NEW/DEACTIVATE/REACTIVATE/UPDATE/DELETE/GETALL
	)
as
begin

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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			INSERT INTO PayTaleGroup (GName, GType, GCreator, GAuditor, Active)
			VALUES (@GName, @GType, @GCreator, @GAuditor, 1)

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
		SET Active = 0, GName = GETDATE(), GAuditor
		WHERE GName = @GName and GCreator=@GCreator

		SET @StatusCode = 2
		SET @Description = 'DEACTIVATESUCCESS'
	END
	ELSE IF (@Action = 'REACTIVATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleGroup
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = 1
			WHERE GName = @GName AND GCreator=@GCreator

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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			DELETE
			FROM PayTaleGroup
			WHERE GName = @GName AND GCreator=@GCreator

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
				WHERE GName = @GName AND GCreator=@GCreator
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = @Active, GName = @GName 
			WHERE GName = @GName AND GCreator=@GCreator

			SET @StatusCode = 7
			SET @Description = 'UPDATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'GROUPNOTEXIST'
		END
	END

	SELECT @StatusCode, @Description

end
	


DROP TABLE PayTaleGTran

CREATE TABLE PayTaleGTran (
	Id BIGINT identity, GroupId BIGINT, GTranCode VARCHAR(max),
	--STARTDATE+TOKEN
	STATUS VARCHAR(max),
	--Closed/Active
	StartDate DATETIME, EndDate DATETIME
	)

drop table PayTales
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

)
drop proc sp_AddPayTale
Create proc sp_AddPayTale
(
@GroupId bigint,
  @MemberId bigint,
  @MTypeId bigint ,
  @Amount decimal,
  @Category varchar(max),
  @Note varchar(max),
  @BillSnap varchar(max)

)
as
begin
Insert into PayTales(GroupId ,
  MemberId ,
  MTypeId  ,
  Amount ,
  Category ,
  Note ,
  BillSnap )  values(@GroupId ,
  @MemberId ,
  @MTypeId  ,
  @Amount ,
  @Category ,
  @Note ,
  @BillSnap ) 
end

Select b.MemberName,a.Amount,a.Category,a.Note,a.PayTaleDate from PayTales a
inner join GMembers b on a.MemberId=b.MemberId where a.GroupId=@GroupId and 
PayTaleDate between 
DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)

--SELECT DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 'FirstDayOfMonth',
-- DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) 'LastDayOfMonth',
--  DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) 'LastDayOfPreviousMonth',
--DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0) 'FirstDayOfNextMonth'

GroupWallet[Month]
  Member
  MAdvance [MAdvance,GAdvance,AuditorAdvance-ideally zero]
  WalletBalance =   (Sum(MAdvance)- ( GAMExPay>0?Sum(MAdvance):GAMHand  ))
[Screen4]

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


**GAMHand is Sum( GAM ExPay List)
**GAMExPay is Formula => *GAMExPay(+0)=(GAMHand-(Sum(MAdvance))>0?Equated:0

AuditReport[Month] -  MAdvance -  ExPay[*GAMExPay(+-)=((GAMHand(GAdvance+OwnExPay))-Sum(MAdvance))>0?Equated:0] -
 DividedAmount[TotalContributedAmount/Members]  - DueAmount[DividedAmount-(MAdvance+ExPay)]
  Group[TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)]
  Member
  Group[TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ]  
[Screen5]

drop proc sp_PayTaleRpt
Create proc sp_PayTaleRpt
(@GroupId bigint)
as
begin
Declare @GroupAdvance decimal
Declare @GAMExPay decimal
Declare @GAMHand decimal
Declare @GABalance decimal
Declare @WalletBalance decimal

--Declare @SampleTable Table(id int, Name varchar(max))  
  
--Insert into @SampleTable(id,Name)values(@ID,@TempName)  
  
--select*from @SampleTable  
  
create table #spWalletBalancePlus
(    
    GroupAdvance   decimal,
    WalletBalance decimal,
    GAMHand decimal,
    GAMExPay decimal
)

insert into #spWalletBalancePlus exec sp_WalletBalalncePlus @GroupId=@GroupId
select @GroupAdvance=@GroupAdvance,@WalletBalance=@WalletBalance,@GAMHand=@GAMHand,@GAMExPay=@GAMExPay from #spWalletBalancePlus
 
 Declare @TotalContributedAmount decimal
 Declare @GroupMembers int
 set @GroupMembers=(select count(*) from GMembers where @GroupId=@GroupId )
 --set @TotalContributedAmount=
 --@GroupAdvance/@GroupMembejbrs

 --select * from wallet

--Select b.MemberName,sum(a.WalletAmount) 'MAdvance' from Wallet a inner join GMembers b
--on a.MemberId=b.MemberId 
----where a.GroupId=@GroupId
-- group by b.MemberName-- a.MemberId
--union  
--select b.MemberName,sum(a.Amount) ExPay from PayTales a inner join GMembers b
--on a.MemberId=b.MemberId where 
----@GroupId=@GroupId and 
--a.PayTaleDate between 
--DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)
--group by b.MemberName

select t1.MemberName, t1.MAdvance, coalesce(t2.ExPay, 0) ExPay
from 
    (Select b.MemberName,sum(a.WalletAmount) 'MAdvance' from Wallet a inner join GMembers b
on a.MemberId=b.MemberId 
--where a.GroupId=@GroupId
 group by b.MemberName-- a.MemberId
) t1
left join
    (select b.MemberName,sum(case when b.GMemberType='' then a.Amount
	when b.GMemberType='' then 3 end) 
	 ExPay from PayTales a inner join GMembers b
on a.MemberId=b.MemberId where 
--@GroupId=@GroupId and 
a.PayTaleDate between 
DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)
group by b.MemberName
) t2
on
    t1.MemberName = t2.MemberName


AuditReport[Month] - MAdvance -  ExPay[*GAMExPay(+-)=((GAMHand(GAdvance+OwnExPay))-Sum(MAdvance))>0?Equated:0] - DividedAmount[TotalContributedAmount/Members]  - DueAmount[DividedAmount-(MAdvance+ExPay)]
  Group[TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)]
  Member
  Group[TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ]  
[Screen5]

end
GroupType = Food ,Trip ..
GroupType-ExpCategories = Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation





**=> Month wise switch option
Review and notify members


