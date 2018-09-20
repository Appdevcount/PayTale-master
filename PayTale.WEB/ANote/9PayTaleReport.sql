--Select b.MemberName,a.Amount,a.Category,a.Note,a.PayTaleDate from PayTales a
--inner join GMembers b on a.MemberId=b.MemberId where a.GroupId=@GroupId and 
--PayTaleDate between 
--DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) and DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)

--SELECT DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 'FirstDayOfMonth',
-- DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) 'LastDayOfMonth',
--  DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) 'LastDayOfPreviousMonth',
--DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0) 'FirstDayOfNextMonth'

--GroupWallet[Month]
--  Member
--  MAdvance [MAdvance,GAdvance,AuditorAdvance-ideally zero]
--  WalletBalance =   (Sum(MAdvance)- ( GAMExPay>0?Sum(MAdvance):GAMHand  ))
--[Screen4]

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
DividedAmount[TotalContributedAmount/Members]  - DueAmount[DividedAmount-(MAdvance+ExPay)]
  Group[TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)]
  Member
  Group[TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ]  


end
GroupType = Food ,Trip ..
GroupType-ExpCategories = Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation





**=> Month wise switch option
Review and notify members


