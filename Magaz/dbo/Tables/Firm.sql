CREATE TABLE [dbo].[Firm] (
    [Id]     INT          IDENTITY (1, 1) NOT NULL,
    [Name]   VARCHAR (50) NOT NULL,
    [Adress] VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_Firm] PRIMARY KEY CLUSTERED ([Id] ASC)
);

