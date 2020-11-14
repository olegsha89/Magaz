CREATE TABLE [dbo].[Sale] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [CustomerId] INT            CONSTRAINT [DF_Sale_CustomerId] DEFAULT ((6)) NOT NULL,
    [Summ]       DECIMAL (8, 2) CONSTRAINT [DF_Sale_Summ] DEFAULT ((0)) NOT NULL,
    [%]          INT            CONSTRAINT [DF_Sale_%] DEFAULT ((0)) NULL,
    [Summ%]      DECIMAL (8, 2) CONSTRAINT [DF_Sale_Summ%] DEFAULT ((0)) NOT NULL,
    [DateTime]   DATETIME       CONSTRAINT [DF_Sale_DateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Sale] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE TRIGGER [dbo].[SalePersent]
ON dbo.Sale
AFTER INSERT,UPDATE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON


UPDATE [dbo].[Sale]
SET [%] =(
SELECT ([Persent]) FROM  [dbo].[%] 
JOIN [dbo].[Customer] 
ON([dbo].[Customer].[[%]]Id]=[dbo].[%].[Id])
JOIN [dbo].[Sale]
ON ([dbo].[Customer].[Id]=[dbo].[Sale].[CustomerId])
WHERE[dbo].[Sale].[CustomerId] = (SELECT [CustomerId] FROM inserted)
GROUP BY [Persent]
)
WHERE [Id]=(SELECT MAX (ID) FROM [dbo].[Sale] )

UPDATE [dbo].[Sale]
SET [Summ%] = 
(
(SELECT [Summ] FROM [dbo].[Sale] WHERE Id=(SELECT MAX (ID) FROM [dbo].[Sale] ))
-
(SELECT((SELECT [Summ] FROM [dbo].[Sale] WHERE Id=(SELECT MAX (ID) FROM [dbo].[Sale]))
*
(SELECT [%] FROM [dbo].[Sale] WHERE Id=(SELECT MAX (ID) FROM [dbo].[Sale]))/ 100)
))
WHERE [dbo].[Sale].Id=(SELECT MAX (ID) FROM [dbo].[Sale])