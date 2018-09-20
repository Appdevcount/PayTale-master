DROP TABLE MemberType

CREATE TABLE MemberType (
	MTypeId BIGINT identity, MType VARCHAR(max) -- Member/Auditor
	)
	
Insert into MemberType(MType) values 
('Member'),('Auditor');