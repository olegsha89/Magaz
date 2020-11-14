CREATE TABLE [dbo].[InvoiceProduct] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceId]     INT            NOT NULL,
    [ProductId]     INT            NULL,
    [TypeProductId] INT            NULL,
    [Quantity]      INT            NOT NULL,
    [Price]         DECIMAL (8, 2) NOT NULL,
    [Name]          VARCHAR (50)   NULL,
    [MarkUp]        INT            NULL,
    CONSTRAINT [PK_Invoice_Product] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_InvoiceProduct_Invoice] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([Id]),
    CONSTRAINT [FK_InvoiceProduct_Product1] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])
);


GO
ALTER TABLE [dbo].[InvoiceProduct] NOCHECK CONSTRAINT [FK_InvoiceProduct_Product1];


GO

CREATE TRIGGER [dbo].[InsertIntoProduct]
ON [dbo].[InvoiceProduct]
AFTER INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

IF EXISTS (SELECT [Id]FROM [dbo].[Product]WHERE[Id] =(SELECT[ProductId] FROM inserted) )

BEGIN
  IF (SELECT inserted.[Price] FROM inserted )>=
  (SELECT[dbo].[Product].[Price] FROM [dbo].[Product] JOIN inserted
 ON [dbo].[Product].[Id]=inserted.[ProductId] )
 UPDATE [dbo].[Product]
 SET
[Price]=inserted.[Price],
[Quantity]=[dbo].[Product].[Quantity]+inserted.[Quantity] FROM [dbo].[Product] JOIN inserted
 ON [dbo].[Product].[Id]=inserted.[ProductId] 
 ELSE
 UPDATE [dbo].[Product]
 SET
[Price]=(SELECT[dbo].[Product].[Price] FROM[dbo].[Product]
JOIN inserted
 ON [dbo].[Product].[Id]=inserted.[ProductId] ),
 [Quantity]=[dbo].[Product].[Quantity]+inserted.[Quantity] FROM [dbo].[Product] JOIN inserted
 ON [dbo].[Product].[Id]=inserted.[ProductId] 
 
 END
 ELSE
  INSERT INTO [dbo].[Product]([Id], [Name],[Price],[Quantity],[TypeProductId],[MarkUp]) 
SELECT [ProductId],[Name],[Price],[Quantity],[TypeProductId],[MarkUp] FROM inserted
GO
CREATE TRIGGER [dbo].[InvoiceProducytUpdate]
ON [dbo].[InvoiceProduct]
AFTER DELETE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE [dbo].[Product]
SET[dbo].[Product].[Quantity]=
(SELECT [Quantity] FROM [dbo].[Product]  WHERE [Id]=(SELECT[ProductId]FROM deleted))

- (SELECT[Quantity]FROM deleted)

WHERE [dbo].[Product].[Id]=  (SELECT deleted.[ProductId] FROM deleted)

--WHERE [Id]=(SELECT[ProductId]FROM deleted)
--JOIN deleted
--ON [ProductId].deleted=[dbo].[Product].[Id]
--WHERE [Id]=(SELECT[ProductId]FROM deleted)