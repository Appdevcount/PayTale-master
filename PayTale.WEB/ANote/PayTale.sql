--PayTale Version 1
--========
DROP TABLE PayTaleUser
Create Table PayTaleUser
(
MemberId bigint identity,
MemberName varchar(max),
UserEmail varchar(max),
Password varchar(max),
JoinedDate datetime default getdate(), 
Active bit,
LeftDate datetime ,
ReJoinedDate datetime ,
)

DROP TABLE PayTaleGroup
Create Table PayTaleGroup
(
GroupId bigint identity,
GName varchar(max),
GType varchar(max),--Food,Trip
GCreator varchar(max),
GAuditor varchar(max) --Auditor of the month/Cause
)
DROP TABLE ExpenseCategory
Create Table ExpenseCategory
(
Id bigint identity,
ExpCategory varchar(max)--Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation
)
DROP TABLE MemberType
Create Table MemberType
(
MTypeId bigint identity,
MType varchar(max)-- Member/Auditor
)
DROP TABLE GMembers
Create Table  GMembers
(
Id bigint identity,
GroupId bigint ,
MemberId bigint ,
MemberName  varchar(max) ,
GMemberType varchar(max), -- Member/AOM/AOC/Auditor
Active bit
)
Drop Table PayTaleGTran
Create Table PayTaleGTran
(

  Id bigint identity,
  GroupId bigint,
  GTranCode varchar(max),--STARTDATE+TOKEN
  Status varchar(max),--Closed/Active
  StartDate datetime,
  EndDate datetime
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
  Type varchar(max),
  AddedDate datetime ,
)
Select b.MemberName,a.MAdvance,a.AddedDate from Wallet a inner join PayTaleUser b on a.MemberId=b.MemberId where GroupId=GroupId


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

Select b.MemberName,sum(a.MAdvance) 'MAdvance' from Wallet a inner join GMembers b
on a.MemberId=b.MemberId 
--where a.GroupId=@GroupId
 group by b.MemberName-- a.MemberId
union all 
select b.MemberName,sum(a.Amount) ExPay from PayTales a inner join GMembers b
on a.MemberId=b.MemberId where 
--@GroupId=@GroupId and 
a.PayTaleDate between 
DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)
group by b.MemberName

DividedAmount[TotalContributedAmount/Members]  - DueAmount[DividedAmount-(MAdvance+ExPay)]
  Group[TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)]
  Member
  Group[TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ]  


end
GroupType = Food ,Trip ..
GroupType-ExpCategories = Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation





**=> Month wise switch option
Review and notify members


