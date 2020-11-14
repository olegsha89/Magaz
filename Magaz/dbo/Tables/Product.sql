CREATE TABLE [dbo].[Product] (
    [Id]            INT             NOT NULL,
    [Name]          VARCHAR (50)    NOT NULL,
    [Price]         DECIMAL (10, 2) CONSTRAINT [DF_Product_Price] DEFAULT ((0)) NOT NULL,
    [Quantity]      INT             CONSTRAINT [DF_Product_Quantity] DEFAULT ((0)) NOT NULL,
    [SalePrice]     DECIMAL (10, 2) NULL,
    [TypeProductId] INT             NULL,
    [MarkUp]        INT             CONSTRAINT [DF_Product_MarkUp] DEFAULT ((20)) NOT NULL,
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Product_Type_product] FOREIGN KEY ([TypeProductId]) REFERENCES [dbo].[TypeProduct] ([Id]) ON DELETE SET NULL ON UPDATE CASCADE
);


GO
CREATE TRIGGER AfterIntoProductMarkUp
ON dbo.Product
AFTER INSERT, UPDATE 
AS
IF @@ROWCOUNT=0
RETURN
SET NOCOUNT ON

UPDATE[dbo].[Product]
SET [SalePrice]=(
SELECT (SELECT [Price] FROM inserted WHERE ID=(SELECT ID FROM inserted))*
(100.+(SELECT[MarkUp]FROM inserted WHERE ID=(SELECT ID FROM inserted)))/100)
WHERE ID=(SELECT ID FROM inserted)