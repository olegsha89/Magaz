CREATE TABLE [dbo].[SaleProduct] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [ProductId] INT            NOT NULL,
    [SaleId]    INT            NULL,
    [Count]     INT            CONSTRAINT [DF_SaleProduct_Count] DEFAULT ((1)) NOT NULL,
    [SalePrice] DECIMAL (8, 2) CONSTRAINT [DF_SaleProduct_SalePrice] DEFAULT ((0)) NOT NULL,
    [Summ]      DECIMAL (8, 2) CONSTRAINT [DF_SaleProduct_Summ] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Sale_Product_1] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Sale_Product_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
    CONSTRAINT [FK_Sale_Product_Sale] FOREIGN KEY ([SaleId]) REFERENCES [dbo].[Sale] ([Id])
);


GO
ALTER TABLE [dbo].[SaleProduct] NOCHECK CONSTRAINT [FK_Sale_Product_Sale];


GO
CREATE TRIGGER [dbo].[OutOfStock]
ON [dbo].[SaleProduct]
INSTEAD OF INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON
IF (SELECT [Quantity] FROM [dbo].[Product] WHERE [Id]= (SELECT[ProductId]FROM inserted))=0
BEGIN
PRINT
'Товару немає В наявності'

ROLLBACK TRAN
END
ELSE 
INSERT INTO [dbo].[SaleProduct]([ProductId],[Count]) SELECT
[ProductId],[Count]
FROM inserted
GO
CREATE TRIGGER AfterUpdateQuantitySaleProduct
ON [dbo].[SaleProduct]
AFTER UPDATE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON
UPDATE [dbo].[Product]
SET [Quantity]=
(SELECT [Quantity] FROM [dbo].[Product] WHERE [Id]=(SELECT[ProductId]FROM inserted) )+
((SELECT[Count]FROM deleted WHERE id=(select id from deleted) )-
(SELECT [Count]FROM inserted WHERE id=(select id from inserted) ))
WHERE [dbo].[Product].[Id]=(SELECT[ProductId]FROM inserted)
GO
CREATE TRIGGER AfterUpdateCountSaleProduct
ON [dbo].[SaleProduct]
AFTER UPDATE
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE[dbo].[SaleProduct]
SET [Summ]= (SELECT((SELECT [Count] FROM inserted)*
(SELECT [SalePrice] FROM [dbo].[SaleProduct] WHERE [Id]= (SELECT[Id]FROM inserted))))
WHERE [Id]=(SELECT[Id]FROM inserted)
/*
BEGIN
IF (SELECT [Count] FROM inserted)>(SELECT[Count] FROM[dbo].[SaleProduct]WHERE[Id]=(SELECT id FROM inserted))

UPDATE[dbo].[Product]
SET[Quantity]=((SELECT[Count] FROM[dbo].[SaleProduct]WHERE[Id]=(SELECT id FROM inserted))-
(SELECT [Count] FROM inserted)) + (SELECT[Count] FROM[dbo].[SaleProduct]WHERE[Id]=(SELECT id FROM inserted))
WHERE [dbo].[Product].[Id]=(SELECT id FROM inserted)
ELSE
*/
UPDATE[dbo].[Product]
SET[Quantity]=((SELECT [Count] FROM inserted)+
(SELECT[Count] FROM[dbo].[SaleProduct]WHERE[Id]=(SELECT id FROM inserted)))-
(SELECT[Count] FROM[dbo].[SaleProduct]WHERE[Id]=(SELECT id FROM inserted))
WHERE [dbo].[Product].[Id]=(SELECT id FROM inserted)
GO
CREATE TRIGGER [dbo].[MaxQuantityProduct]
ON [dbo].[SaleProduct]
AFTER INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON
BEGIN


IF (SELECT [Count]FROM inserted)>
(SELECT [Quantity] FROM [dbo].[Product] WHERE [Id]= (SELECT[ProductId]FROM inserted))

BEGIN
UPDATE [dbo].[SaleProduct]
SET [Count]= (SELECT [Quantity] FROM [dbo].[Product] WHERE[Id]=(SELECT[ProductId]FROM inserted))
WHERE[Id]=( SELECT[Id]FROM inserted)

UPDATE [dbo].[Product]
SET [Quantity]=  0
WHERE [dbo].[Product].[Id]=(SELECT[ProductId]FROM inserted) 
PRINT
'Залишки Вичерпані Макс доступна кількість'
END

ELSE



BEGIN


UPDATE [dbo].[Product]
SET [Quantity]= 
((SELECT [Quantity] FROM [dbo].[Product] WHERE [Id]= (SELECT[ProductId]FROM inserted))
-(SELECT [Count] FROM inserted ))

WHERE [dbo].[Product].[Id]=(SELECT[ProductId]FROM inserted) 

END
END
GO
CREATE TRIGGER [dbo].[SaleSumm]
ON dbo.SaleProduct
AFTER INSERT,UPDATE 
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON


 UPDATE [dbo].[Sale]
 SET [Summ]=
 (SELECT SUM([Summ])FROM [dbo].[SaleProduct] WHERE [SaleId] =(SELECT MAX (ID) FROM [dbo].[Sale] ))
 WHERE [Id]=(SELECT MAX (ID) FROM [dbo].[Sale] )
GO
CREATE TRIGGER [dbo].[SaleProductPrice]
ON [dbo].[SaleProduct]
AFTER INSERT
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE [dbo].[SaleProduct]
SET[SaleId]=(SELECT MAX (ID) FROM [dbo].[Sale] )
WHERE [Id]= (SELECT MAX([Id]) FROM[dbo].[SaleProduct])



UPDATE [dbo].[SaleProduct]
SET [SalePrice] = (SELECT[SalePrice]FROM[dbo].[Product] WHERE [dbo].[Product].[Id]=
(SELECT [ProductId] FROM inserted) )



WHERE [Id]= (SELECT MAX([Id]) FROM[dbo].[SaleProduct])

UPDATE [dbo].[SaleProduct]
SET [Summ] = (SELECT[Count]FROM[dbo].[SaleProduct]WHERE [Id]= (SELECT MAX([Id]) FROM[dbo].[SaleProduct]))
*
(SELECT[SalePrice]FROM[dbo].[SaleProduct] WHERE [dbo].[SaleProduct].[ProductId]=
(SELECT [ProductId] FROM inserted) AND [Id]= (SELECT MAX([Id]) FROM[dbo].[SaleProduct]))
WHERE [Id]= (SELECT MAX([Id]) FROM[dbo].[SaleProduct])