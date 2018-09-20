DECLARE @RC int
DECLARE @GroupId bigint
DECLARE @MemberId bigint
DECLARE @MemberName varchar
DECLARE @GMemberType varchar
DECLARE @Active bit
DECLARE @Action varchar

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_GMembersAction] 
   @GroupId
  ,@MemberId
  ,@MemberName
  ,@GMemberType
  ,@Active
  ,@Action
GO


DECLARE @RC int
DECLARE @GroupId bigint
DECLARE @STATUS varchar

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_GTranAction] 
   @GroupId
  ,@STATUS
GO


DECLARE @RC int
DECLARE @GName varchar
DECLARE @GType varchar
DECLARE @GCreator varchar
DECLARE @GAuditor varchar
DECLARE @Action varchar

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_PayTaleGroupAction] 
   @GName
  ,@GType
  ,@GCreator
  ,@GAuditor
  ,@Action
GO


DECLARE @RC int
DECLARE @GroupId bigint

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_PayTaleRpt] 
   @GroupId
GO


DECLARE @RC int
DECLARE @PayID bigint
DECLARE @GroupId bigint
DECLARE @GTranCode varchar
DECLARE @MemberId bigint
DECLARE @MTypeId bigint
DECLARE @Amount decimal(18,0)
DECLARE @Category varchar
DECLARE @Note varchar
DECLARE @BillSnap varchar
DECLARE @Action varchar
DECLARE @PayMaster varchar

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_PayTalesAction] 
   @PayID
  ,@GroupId
  ,@GTranCode
  ,@MemberId
  ,@MTypeId
  ,@Amount
  ,@Category
  ,@Note
  ,@BillSnap
  ,@Action
  ,@PayMaster
GO


DECLARE @RC int
DECLARE @MemberName varchar
DECLARE @UserEmail varchar
DECLARE @Password varchar
DECLARE @Active bit
DECLARE @Action varchar

-- TODO: Set parameter values here.

EXECUTE @RC = [PayTale].[dbo].[sp_UserAction] 
   @MemberName
  ,@UserEmail
  ,@Password
  ,@Active
  ,@Action
GO




