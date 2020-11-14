CREATE TABLE [dbo].[Borh] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceId] INT            NOT NULL,
    [Borh]      DECIMAL (8, 2) NOT NULL,
    CONSTRAINT [PK_Zaluchok] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Zaluchok_Invoice] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[Invoice] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

