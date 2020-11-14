CREATE TABLE [dbo].[Customer] (
    [Id]     INT          IDENTITY (2, 1) NOT NULL,
    [Name]   VARCHAR (20) NULL,
    [Phone]  INT          NOT NULL,
    [[%]]Id] INT          NOT NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Customer_%] FOREIGN KEY ([[%]]Id]) REFERENCES [dbo].[%] ([Id])
);

