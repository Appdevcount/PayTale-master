DROP TABLE ExpenseCategory

CREATE TABLE ExpenseCategory (
	Id BIGINT identity
	,ExpCategory VARCHAR(max) --Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation
	)

INSERT INTO ExpenseCategory (ExpCategory)
VALUES ('Restuarant')
	,('HouseholdItems')
	,('CookingItems')
	,('Others')
	,('Automobile')
	,('Donation')
	,('Gifts')
	,('Entertainment')
	,('Transportation');
