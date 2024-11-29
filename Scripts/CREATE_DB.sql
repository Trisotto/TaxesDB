IF EXISTS(SELECT 1 from sys.databases WHERE NAME = 'TaxesDB')
DROP DATABASE [TaxesDB]
GO

CREATE DATABASE [TaxesDB]
GO
USE [TaxesDB]
GO

CREATE  TABLE dbo.ENTITY_TYPE ( 
	ID_ENTITY_TYPE_PK    smallint      NOT NULL,
	DE_ENTITY_TYPE       varchar(50)      NOT NULL,
	CONSTRAINT PK_ENTITY_TYPE PRIMARY KEY  ( ID_ENTITY_TYPE_PK ) ,
	CONSTRAINT UNQ_DE_ENTITY_TYPE UNIQUE ( DE_ENTITY_TYPE ) 
 );
GO

CREATE  TABLE dbo.PHONE_TYPE ( 
	ID_PHONE_TYPE_PK     int    IDENTITY  NOT NULL,
	DE_PHONE_TYPE        varchar(50)      NOT NULL,
	CONSTRAINT PK_PHONE_TYPE PRIMARY KEY  ( ID_PHONE_TYPE_PK ) ,
	CONSTRAINT UNQ_PHONE_TYPE UNIQUE ( DE_PHONE_TYPE ) 
 );
GO

CREATE  TABLE dbo.TAX_TYPE ( 
	ID_TAX_TYPE_PK       int    IDENTITY  NOT NULL,
	DE_TAX_TYPE          varchar(50)      NOT NULL,
	CONSTRAINT PK_TAX_TYPE PRIMARY KEY  ( ID_TAX_TYPE_PK ) ,
	CONSTRAINT UNQ_TAX_TYPE UNIQUE ( DE_TAX_TYPE ) 
 );
GO

CREATE  TABLE dbo.ENTITIES ( 
	ID_ENTITY_PK         int    IDENTITY  NOT NULL,
	ID_ENTITY_TYPE_FK    smallint      NOT NULL,
	ADDRESS              varchar(200)      NULL,
	EMAIL                varchar(50)      NULL,
	CONSTRAINT PK_ENTITIES PRIMARY KEY  ( ID_ENTITY_PK ) ,
	CONSTRAINT UNQ_ENTITIES UNIQUE ( ID_ENTITY_PK, ID_ENTITY_TYPE_FK ) ,
	CONSTRAINT CNS_ID_ENTITY_TYPE_FK CHECK ( [ID_ENTITY_TYPE_FK]=(3) OR [ID_ENTITY_TYPE_FK]=(2) OR [ID_ENTITY_TYPE_FK]=(1) )
 );
GO

CREATE  TABLE dbo.PHONES ( 
	ID_PHONE_PK          int    IDENTITY  NOT NULL,
	ID_ENTITY_FK         int      NOT NULL,
	ID_PHONE_TYPE_FK     int      NOT NULL,
	PHONE_NUMBER         varchar(50)      NOT NULL,
	CONSTRAINT PK_PHONES PRIMARY KEY  ( ID_PHONE_PK ) ,
	CONSTRAINT UNQ_PHONES UNIQUE ( ID_ENTITY_FK, ID_PHONE_TYPE_FK, PHONE_NUMBER ) 
 );
GO

CREATE  TABLE dbo.AGENCIES ( 
	ID_ENTITY_PK_FK      int      NOT NULL,
	ID_ENTITY_TYPE_PK_FK smallint  DEFAULT 3    NOT NULL,
	AGENCY_NUMBER        varchar(15)      NOT NULL,
	CONSTRAINT PK_AGENCIES PRIMARY KEY  ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) ,
	CONSTRAINT UNQ_AGENCIES_ID_ENTITY UNIQUE ( ID_ENTITY_PK_FK ) ,
	CONSTRAINT UNQ_AGENCIES_AGENCY_NUMBER UNIQUE ( AGENCY_NUMBER ) ,
	CONSTRAINT CNS_AGENCIES_ID_ENTITY_TYPE_PK_FK CHECK ( [ID_ENTITY_TYPE_PK_FK]=(3) )
 );
GO

CREATE  TABLE dbo.COMPANIES ( 
	ID_ENTITY_PK_FK      int      NOT NULL,
	ID_ENTITY_TYPE_PK_FK smallint  DEFAULT 2    NOT NULL,
	CUIT_NUMBER          varchar(20)      NOT NULL,
	DT_COMMENCEMENT      date      NOT NULL,
	WEBSITE              varchar(200)      NULL,
	CONSTRAINT PK_COMPANIES PRIMARY KEY  ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) ,
	CONSTRAINT UNQ_COMPANIES_ID_ENTITY UNIQUE ( ID_ENTITY_PK_FK ) ,
	CONSTRAINT UNQ_COMPANIES_CUIT_NUMBER UNIQUE ( CUIT_NUMBER ) ,
	CONSTRAINT CNS_COMPANIES_ID_ENTITY_TYPE_PK_FK CHECK ( [ID_ENTITY_TYPE_PK_FK]=(2) )
 );
GO

CREATE  TABLE dbo.INDIVIDUALS ( 
	ID_ENTITY_PK_FK      int      NOT NULL,
	ID_ENTITY_TYPE_PK_FK smallint      NOT NULL,
	DOCUMENT_NUMBER      varchar(20)      NOT NULL,
	FULL_NAME            varchar(100)      NOT NULL,
	DT_BIRTH             date      NOT NULL,
	ID_AGENCY_EMPLOYER_FK int      NULL,
	CONSTRAINT PK_INDIVIDUALS PRIMARY KEY  ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) ,
	CONSTRAINT UNQ_INDIVIDUALS_DOCUMENT_NUMBER UNIQUE ( DOCUMENT_NUMBER ) ,
	CONSTRAINT UNQ_INDIVIDUALS_ID_ENTITY UNIQUE ( ID_ENTITY_PK_FK ) ,
	CONSTRAINT CNS_ID_ENTITY_TYPE_PK_FK CHECK ( [ID_ENTITY_TYPE_PK_FK]=(1) )
 );
GO

CREATE  TABLE dbo.TAX_PAYMENTS ( 
	ID_TAX_PAYMENTS_PK   int    IDENTITY  NOT NULL,
	ID_TAX_TYPE_FK       int      NOT NULL,
	ID_AGENCY_ENTITY_FK  int      NOT NULL,
	ID_TAXPAYER_ENTITY_FK int      NOT NULL,
	DT_PAYMENT           date      NOT NULL,
	AMOUNT               decimal(12,2)      NOT NULL,
	CONSTRAINT PK_TAX_PAYMENTS PRIMARY KEY  ( ID_TAX_PAYMENTS_PK ) ,
	CONSTRAINT UNQ_TAX_PAYMENTS UNIQUE ( ID_TAX_TYPE_FK, ID_AGENCY_ENTITY_FK, ID_TAXPAYER_ENTITY_FK, DT_PAYMENT ) 
 );
GO

CREATE  TABLE dbo.AGENCY_MANAGERS ( 
	ID_AGENCY_ENTITY_PK_FK int      NOT NULL,
	ID_MANAGER_ENTITY_PK_FK int      NOT NULL,
	CONSTRAINT PK_AGENCY_MANAGERS PRIMARY KEY  ( ID_AGENCY_ENTITY_PK_FK, ID_MANAGER_ENTITY_PK_FK ) 
 );
GO

CREATE  TABLE dbo.COMPANY_OWNERS ( 
	ID_COMPANY_ENTITY_PK_FK int      NOT NULL,
	ID_OWNER_ENTITY_PK_FK int      NOT NULL,
	CONSTRAINT PK_COMPANY_OWNERS PRIMARY KEY  ( ID_COMPANY_ENTITY_PK_FK, ID_OWNER_ENTITY_PK_FK ) 
 );
GO

ALTER TABLE dbo.AGENCIES ADD CONSTRAINT FK_AGENCIES_ENTITIES FOREIGN KEY ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) REFERENCES dbo.ENTITIES( ID_ENTITY_PK, ID_ENTITY_TYPE_FK );
GO

ALTER TABLE dbo.AGENCY_MANAGERS ADD CONSTRAINT FK_AGENCY_MANAGERS_AGENCIES FOREIGN KEY ( ID_AGENCY_ENTITY_PK_FK ) REFERENCES dbo.AGENCIES( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.AGENCY_MANAGERS ADD CONSTRAINT FK_AGENCY_MANAGERS_INDIVIDUALS FOREIGN KEY ( ID_MANAGER_ENTITY_PK_FK ) REFERENCES dbo.INDIVIDUALS( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.COMPANIES ADD CONSTRAINT FK_COMPANIES_ENTITIES FOREIGN KEY ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) REFERENCES dbo.ENTITIES( ID_ENTITY_PK, ID_ENTITY_TYPE_FK );
GO

ALTER TABLE dbo.COMPANY_OWNERS ADD CONSTRAINT FK_COMPANY_OWNERS_COMPANIES FOREIGN KEY ( ID_COMPANY_ENTITY_PK_FK ) REFERENCES dbo.COMPANIES( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.COMPANY_OWNERS ADD CONSTRAINT FK_COMPANY_OWNERS_INDIVIDUALS FOREIGN KEY ( ID_OWNER_ENTITY_PK_FK ) REFERENCES dbo.INDIVIDUALS( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.ENTITIES ADD CONSTRAINT FK_ENTITIES_ENTITY_TYPE FOREIGN KEY ( ID_ENTITY_TYPE_FK ) REFERENCES dbo.ENTITY_TYPE( ID_ENTITY_TYPE_PK );
GO

ALTER TABLE dbo.INDIVIDUALS ADD CONSTRAINT FK_INDIVIDUALS_ENTITIES FOREIGN KEY ( ID_ENTITY_PK_FK, ID_ENTITY_TYPE_PK_FK ) REFERENCES dbo.ENTITIES( ID_ENTITY_PK, ID_ENTITY_TYPE_FK );
GO

ALTER TABLE dbo.INDIVIDUALS ADD CONSTRAINT FK_INDIVIDUALS_AGENCIES FOREIGN KEY ( ID_AGENCY_EMPLOYER_FK ) REFERENCES dbo.AGENCIES( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.PHONES ADD CONSTRAINT FK_PHONES_ENTITIES FOREIGN KEY ( ID_ENTITY_FK ) REFERENCES dbo.ENTITIES( ID_ENTITY_PK );
GO

ALTER TABLE dbo.PHONES ADD CONSTRAINT FK_PHONES_PHONE_TYPE FOREIGN KEY ( ID_PHONE_TYPE_FK ) REFERENCES dbo.PHONE_TYPE( ID_PHONE_TYPE_PK );
GO

ALTER TABLE dbo.TAX_PAYMENTS ADD CONSTRAINT FK_TAX_PAYMENTS_AGENCIES FOREIGN KEY ( ID_AGENCY_ENTITY_FK ) REFERENCES dbo.AGENCIES( ID_ENTITY_PK_FK );
GO

ALTER TABLE dbo.TAX_PAYMENTS ADD CONSTRAINT FK_TAX_PAYMENTS_ENTITIES FOREIGN KEY ( ID_TAXPAYER_ENTITY_FK ) REFERENCES dbo.ENTITIES( ID_ENTITY_PK );
GO

ALTER TABLE dbo.TAX_PAYMENTS ADD CONSTRAINT FK_TAX_PAYMENTS_TAX_TYPE FOREIGN KEY ( ID_TAX_TYPE_FK ) REFERENCES dbo.TAX_TYPE( ID_TAX_TYPE_PK );
GO

CREATE FUNCTION [dbo].[FN_GET_QTY_EMPLOYEES](
@P_ID_AGENCY_EMPLOYER INT)  
RETURNS INT
AS
BEGIN  
	DECLARE @V_QTY_EMPLOYEES INT;

	SELECT @V_QTY_EMPLOYEES = COUNT(I.ID_ENTITY_PK_FK)
 	  FROM [dbo].[INDIVIDUALS] I WITH(NOLOCK)
	 WHERE I.ID_AGENCY_EMPLOYER_FK = @P_ID_AGENCY_EMPLOYER;

 RETURN @V_QTY_EMPLOYEES;
END;
GO

ALTER TABLE dbo.AGENCIES ADD QTY_EMPLOYEES AS ([dbo].[FN_GET_QTY_EMPLOYEES]([ID_ENTITY_PK_FK]));
GO