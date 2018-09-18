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
	, Active BIT
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
				WHERE GName = @GName
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
			SET @Description = 'USEREXISTS'
		END
	END
	ELSE IF (@Action = 'DEACTIVATE')
	BEGIN
		UPDATE PayTaleGroup
		SET Active = 0, GName = GETDATE(), GAuditor
		WHERE GName = @GName

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
	ELSE IF (@Action = 'UPDATE')
	BEGIN
		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM PayTaleUser
				WHERE UserEmail = @UserEmail
				)
		BEGIN
			UPDATE PayTaleGroup
			SET Active = 0, GName = GETDATE(), GAuditor
			WHERE GName = @GName

			SET @StatusCode = 7
			SET @Description = 'UPDATESUCCESS'
		END
		ELSE
		BEGIN
			SET @StatusCode = 6
			SET @Description = 'USERNOTEXIST'
		END
	END

	SELECT @StatusCode, @Description
END

DROP TABLE ExpenseCategory

CREATE TABLE ExpenseCategory (
	Id BIGINT identity, ExpCategory VARCHAR(max) --Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation
	)

DROP TABLE MemberType

CREATE TABLE MemberType (
	MTypeId BIGINT identity, MType VARCHAR(max) -- Member/Auditor
	)

DROP TABLE GMembers

CREATE TABLE GMembers (
	Id BIGINT identity, GroupId BIGINT, MemberId BIGINT, MemberName VARCHAR(max), GMemberType VARCHAR(max),
	-- Member/AOM/AOC/Auditor
	Active BIT
	)

DROP TABLE PayTaleGTran

CREATE TABLE PayTaleGTran (
	Id BIGINT identity, GroupId BIGINT, GTranCode VARCHAR(max),
	--STARTDATE+TOKEN
	STATUS VARCHAR(max),
	--Closed/Active
	StartDate DATETIME, EndDate DATETIME
	)

DROP TABLE PayTales

CREATE TABLE PayTales (
	Id BIGINT identity, GroupId BIGINT, GTranCode VARCHAR(max),
	--STARTDATE+TOKEN
	MemberId BIGINT, MTypeId BIGINT, Amount DECIMAL, Category VARCHAR(max), Note VARCHAR(max), BillSnap VARCHAR(max), PayTaleDate DATETIME DEFAULT getdate(),
	)

DROP PROC sp_AddPayTale

CREATE PROC sp_AddPayTale (@GroupId BIGINT, @MemberId BIGINT, @MTypeId BIGINT, @Amount DECIMAL, @Category VARCHAR(max), @Note VARCHAR(max), @BillSnap VARCHAR(max))
AS
BEGIN
	INSERT INTO PayTales (GroupId, MemberId, MTypeId, Amount, Category, Note, BillSnap)
	VALUES (@GroupId, @MemberId, @MTypeId, @Amount, @Category, @Note, @BillSnap)
END

SELECT b.MemberName, a.Amount, a.Category, a.Note, a.PayTaleDate
FROM PayTales a
INNER JOIN GMembers b ON a.MemberId = b.MemberId
WHERE a.GroupId = @GroupId AND PayTaleDate BETWEEN DATEADD(DAY, - (DAY(GETDATE())), CAST(GETDATE() AS DATE)) AND DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)

--SELECT DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) 'FirstDayOfMonth',
-- DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) 'LastDayOfMonth',
--  DATEADD(DAY, -(DAY(GETDATE())), CAST(GETDATE() AS DATE)) 'LastDayOfPreviousMonth',
--DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0) 'FirstDayOfNextMonth'
--GroupWallet [Month] Member MAdvance [MAdvance,GAdvance,AuditorAdvance-ideally zero] WalletBalance = (Sum(MAdvance) - (GAMExPay > 0 ?Sum(MAdvance) :GAMHand)) [Screen4]
DROP TABLE wallet

CREATE TABLE Wallet (
	Id BIGINT identity, GroupId BIGINT, GTranCode VARCHAR(max),
	--STARTDATE+TOKEN
	MemberId BIGINT, WalletAmount DECIMAL,
	--MAdvance
	Type VARCHAR(max), AddedDate DATETIME,
	)

SELECT b.MemberName, a.MAdvance, a.AddedDate
FROM Wallet a
INNER JOIN PayTaleUser b ON a.MemberId = b.MemberId
WHERE GroupId = GroupIdDROP PROC sp_WalletBalancePlus

CREATE PROC sp_WalletBalancePlus (@GroupId BIGINT)
AS
BEGIN
	DECLARE @GroupAdvance DECIMAL
	DECLARE @GAMExPay DECIMAL
	DECLARE @GAMHand DECIMAL
	DECLARE @GABalance DECIMAL
	DECLARE @WalletBalance DECIMAL

	SET @GroupAdvance = (
			SELECT Sum(WalletAmount)
			FROM Wallet
			WHERE GroupId = GroupId
			)
	SET @GAMHand = (
			SELECT Sum(Amount)
			FROM PayTales
			WHERE GroupId = GroupId AND MTypeId = MTypeId AND PayTaleDate BETWEEN DATEADD(DAY, - (DAY(GETDATE())), CAST(GETDATE() AS DATE)) AND DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)
			)
	SET @GABalance = @GAMHand - @GroupAdvance

	IF (@GABalance > 0)
	BEGIN
		SET @GAMExPay = @GABalance
	END
	ELSE
	BEGIN
		SET @GAMExPay = 0
	END

	SET @WalletBalance = @GroupAdvance - IIF(@GAMExPay > 0, @GroupAdvance, @GAMHand)

	SELECT @GroupAdvance, @WalletBalance, @GAMHand, @GAMExPay
END

--* * GAMHand IS Sum(GAM ExPay List) * * GAMExPay IS Formula = > * GAMExPay(+ 0) = (
--		GAMHand - (Sum(MAdvance)) > 0 ?Equated: 0 AuditReport [Month] - MAdvance - ExPay [*GAMExPay(+-)=((GAMHand(GAdvance+OwnExPay))-Sum(MAdvance))>0?Equated:0] - DividedAmount [TotalContributedAmount/Members] - DueAmount [DividedAmount-(MAdvance+ExPay)] GROUP [TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)] Member
--		GROUP [TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ] [Screen5] 
DROP PROC sp_PayTaleRpt

CREATE PROC sp_PayTaleRpt (@GroupId BIGINT)
AS
BEGIN
	DECLARE @GroupAdvance DECIMAL
	DECLARE @GAMExPay DECIMAL
	DECLARE @GAMHand DECIMAL
	DECLARE @GABalance DECIMAL
	DECLARE @WalletBalance DECIMAL 
DECLARE @SampleTable TABLE (id INT, Name VARCHAR(max))

INSERT INTO @SampleTable (id, Name)
VALUES (@ID, @TempName)

SELECT *
FROM @SampleTable

		CREATE TABLE #spWalletBalancePlus (GroupAdvance DECIMAL, WalletBalance DECIMAL, GAMHand DECIMAL, GAMExPay DECIMAL)					
		INSERT INTO #spWalletBalancePlus EXEC sp_WalletBalalncePlus @GroupId = @GroupId					
		SELECT @GroupAdvance = @GroupAdvance, @WalletBalance = @WalletBalance, @GAMHand = @GAMHand, @GAMExPay = @GAMExPay FROM #spWalletBalancePlus					
		DECLARE @TotalContributedAmount DECIMAL					
		DECLARE @GroupMembers INT					
		SET @GroupMembers = (SELECT count(*) FROM GMembers WHERE @GroupId = @GroupId) --
		set @TotalContributedAmount=''
		--@GroupAdvance/@GroupMembejbrs
		--select * from wallet					
		SELECT b.MemberName, sum(a.MAdvance) 'MAdvance' FROM Wallet a INNER JOIN GMembers b ON a.MemberId = b.MemberId
		where a.GroupId=@GroupId
	GROUP BY b.MemberName -- a.MemberId
	
	UNION ALL
	
	SELECT b.MemberName, sum(a.Amount) ExPay
	FROM PayTales a
	INNER JOIN GMembers b ON a.MemberId = b.MemberId
	WHERE
		--@GroupId=@GroupId and 
		a.PayTaleDate BETWEEN DATEADD(DAY, - (DAY(GETDATE())), CAST(GETDATE() AS DATE)) AND DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)
	GROUP BY b.MemberName DividedAmount [TotalContributedAmount/Members] - DueAmount [DividedAmount-(MAdvance+ExPay)]
	GROUP [TotalContributedAmount=Sum(MAdvance) +Sum(ExPay)] Member
	GROUP [TotalSpentAmount= Sum(ExPay) +GAMExPay>0?Sum(MAdvance):GAMHand   ]
END 
--GroupType = Food, Trip..GroupType - ExpCategories = Restuarant, HouseholdItems, CookingItems, Others, Automobile, Donation, Gifts, Entertainment, Transportation * *= > Month wise switch
--OPTION Review AND notify members )
