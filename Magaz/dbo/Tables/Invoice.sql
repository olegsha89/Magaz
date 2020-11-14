CREATE TABLE [dbo].[Invoice] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Number]    INT            NULL,
    [TorhoviId] INT            NULL,
    [Summ]      DECIMAL (8, 2) NOT NULL,
    [Date]      DATETIME       CONSTRAINT [DF_Invoice_Date] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Invoice_Agent] FOREIGN KEY ([TorhoviId]) REFERENCES [dbo].[Agent] ([Id])
);


GO

CREATE TRIGGER [dbo].[BorhTriggerUpdate]
ON [dbo].[Invoice]
AFTER UPDATE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE [dbo].[Borh]
SET [dbo].[Borh].[Borh] = (SELECT([Summ])FROM[dbo].[Invoice]
WHERE[dbo].[Invoice].Id=inserted.Id)-(SELECT SUM([HowMach])FROM[dbo].[Oplata]
WHERE[dbo].[Oplata].[InvoiceId]=inserted.Id)
FROM [dbo].[Borh] JOIN inserted
ON [dbo].[Borh].[InvoiceId]=inserted.Id
JOIN [dbo].[Oplata]
ON(inserted.Id=[dbo].[Oplata].[InvoiceId])
GO
 CREATE TRIGGER [dbo].[BorhTriggerInsert]
ON [dbo].[Invoice]
AFTER INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

INSERT INTO [dbo].[Borh]
 ([InvoiceId],[Borh]) 
 SELECT [Id],[summ]
 FROM inserted