CREATE TABLE [dbo].[TypeProduct] (
    [Id]   INT          IDENTITY (1, 1) NOT NULL,
    [Name] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Type_product] PRIMARY KEY CLUSTERED ([Id] ASC)
);

