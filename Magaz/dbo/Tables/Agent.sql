CREATE TABLE [dbo].[Agent] (
    [Id]     INT          IDENTITY (1, 1) NOT NULL,
    [Name]   VARCHAR (50) NOT NULL,
    [FirmId] INT          NULL,
    CONSTRAINT [PK_Agent] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Agent_Firm] FOREIGN KEY ([FirmId]) REFERENCES [dbo].[Firm] ([Id])
);

