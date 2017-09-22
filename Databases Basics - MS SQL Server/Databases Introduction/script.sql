/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.1742)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [f_CalculateTotalBalance] (@ClientID int)
RETURNS decimal(15,2)
BEGIN
	DECLARE @result AS decimal(15,2) = (
	SELECT SUM(Balance) 
	FROM Accounts WHERE ClientId = @ClientID
	)
	RETURN @result
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AccountTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Accounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountTypeId] [int] NULL,
	[Balance] [decimal](15, 2) NOT NULL,
	[ClientId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [v_ClientBalances] AS 
SELECT (FirstName + ' ' + LastName) AS [Name], 
(AccountTypes.Name) AS [Account Type], Balance 
FROM Clients
JOIN Accounts ON Clients.Id = Accounts.ClientId
JOIN AccountTypes ON AccountTypes.Id = Accounts.AccountTypeId
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Transactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NULL,
	[OldBalance] [decimal](15, 2) NOT NULL,
	[NewBalance] [decimal](15, 2) NOT NULL,
	[Amount]  AS ([NewBalance]-[OldBalance]),
	[DateTime] [datetime2](7) NULL
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [p_AddAccount] @ClientId int, @AccountTypeId int AS 
INSERT INTO Accounts(ClientId, AccountTypeId)
VALUES (@ClientId, @AccountTypeId)
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [p_Deposit] @AccountId int, @Amount decimal(15,2) AS
UPDATE Accounts
SET Balance += @Amount
WHERE Id = @AccountId
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [p_Withdraw] @AccountId int, @Amount decimal(15,2) AS
BEGIN
	DECLARE @oldBalance decimal(15, 2)
	SELECT @oldBalance = Balance FROM Accounts WHERE Id = @AccountId
	IF (@oldBalance - @Amount >= 0)
	BEGIN
		UPDATE Accounts
		SET Balance -= @Amount
		WHERE Id = @AccountId
	END
	ELSE
	BEGIN
		RAISERROR('Insufficient funds', 10, 1)
	END
END
GO
