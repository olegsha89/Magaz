CREATE TABLE [dbo].[Oplata] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [HowMach]   DECIMAL (8, 2) NOT NULL,
    [Date]      DATE           CONSTRAINT [DF_Oplata_Date] DEFAULT (getdate()) NOT NULL,
    [InvoiceId] INT            NOT NULL,
    CONSTRAINT [PK_Oplata] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Oplata_Invoice] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO

CREATE TRIGGER OplataInvoiceUpdate
ON [dbo].[Oplata]
AFTER UPDATE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE [Borh]
SET [dbo].[Borh].[Borh] =

(SELECT[dbo].[Invoice].[Summ]FROM[dbo].[Invoice] WHERE[dbo].[Invoice].[Id]=inserted.[InvoiceId])

-(SELECT SUM([HowMach])FROM[dbo].[Oplata] WHERE[dbo].[Oplata].[InvoiceId]=inserted.[InvoiceId])
 
FROM [dbo].[Borh] JOIN inserted
ON [dbo].[Borh].[InvoiceId]=inserted.[InvoiceId]
GO

CREATE TRIGGER OplataInvoiceInsert
ON [dbo].[Oplata]
AFTER INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE [Borh]
SET [dbo].[Borh].[Borh] =

(SELECT[dbo].[Invoice].[Summ]FROM[dbo].[Invoice] WHERE[dbo].[Invoice].[Id]=inserted.[InvoiceId])

-(SELECT SUM([HowMach])FROM[dbo].[Oplata] WHERE[dbo].[Oplata].[InvoiceId]=inserted.[InvoiceId])
 
FROM [dbo].[Borh] JOIN inserted
ON [dbo].[Borh].[InvoiceId]=inserted.[InvoiceId]