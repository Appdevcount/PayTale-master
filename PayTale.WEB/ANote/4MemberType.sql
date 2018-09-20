DROP TABLE MemberType

CREATE TABLE MemberType (
	MTypeId BIGINT identity
	,MType VARCHAR(max) -- Member/Auditor
	)

INSERT INTO MemberType (MType)
VALUES ('Member')
	,('Auditor');
