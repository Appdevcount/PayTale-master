
DROP TABLE ExpenseCategory

CREATE TABLE ExpenseCategory (
	Id BIGINT identity, ExpCategory VARCHAR(max) --Restuarant,HouseholdItems,CookingItems,Others,Automobile,Donation,Gifts,Entertainment,Transportation
	)
	
Insert into ExpenseCategory(ExpCategory) values 
('Restuarant'),('HouseholdItems'),('CookingItems'),('Others'),('Automobile'),('Donation'),('Gifts'),('Entertainment'),('Transportation');

