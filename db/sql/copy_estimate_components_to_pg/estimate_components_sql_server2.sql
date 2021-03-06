USE [ca_estim_dev]
GO
/****** Object:  Table [dbo].[estimate_components]    Script Date: 08/11/2013 11:55:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[estimate_components](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[estimate_id] [int] NOT NULL,
	[assembly_id] [int] NOT NULL,
	[component_id] [int] NOT NULL,
	[write_in_name] [nvarchar](255) NOT NULL DEFAULT (N''),
	[value] [decimal](19, 4) NOT NULL DEFAULT ((0)),
	[deactivated] [bit] NOT NULL DEFAULT ((0)),
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[note] [nvarchar](255) NOT NULL DEFAULT (N''),
	[tax_percent] [decimal](19, 4) NULL DEFAULT (NULL),
	[tax_amount] [decimal](19, 2) NULL DEFAULT (NULL),
	[labor_rate_value] [decimal](19, 2) NULL DEFAULT (NULL),
	[labor_value] [decimal](19, 2) NULL DEFAULT (NULL),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [index_estimate_components_on_assembly_id] ON [dbo].[estimate_components] 
(
	[assembly_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [index_estimate_components_on_component_id] ON [dbo].[estimate_components] 
(
	[component_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [index_estimate_components_on_estimate_id] ON [dbo].[estimate_components] 
(
	[estimate_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [unique_estimate_component] ON [dbo].[estimate_components] 
(
	[estimate_id] ASC,
	[assembly_id] ASC,
	[component_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  ForeignKey [estimate_components_assembly_id_fk]    Script Date: 08/11/2013 11:55:33 ******/
ALTER TABLE [dbo].[estimate_components]  WITH CHECK ADD  CONSTRAINT [estimate_components_assembly_id_fk] FOREIGN KEY([assembly_id])
REFERENCES [dbo].[assemblies] ([id])
GO
ALTER TABLE [dbo].[estimate_components] CHECK CONSTRAINT [estimate_components_assembly_id_fk]
GO
/****** Object:  ForeignKey [estimate_components_component_id_fk]    Script Date: 08/11/2013 11:55:33 ******/
ALTER TABLE [dbo].[estimate_components]  WITH CHECK ADD  CONSTRAINT [estimate_components_component_id_fk] FOREIGN KEY([component_id])
REFERENCES [dbo].[components] ([id])
GO
ALTER TABLE [dbo].[estimate_components] CHECK CONSTRAINT [estimate_components_component_id_fk]
GO
/****** Object:  ForeignKey [estimate_components_estimate_id_fk]    Script Date: 08/11/2013 11:55:33 ******/
ALTER TABLE [dbo].[estimate_components]  WITH CHECK ADD  CONSTRAINT [estimate_components_estimate_id_fk] FOREIGN KEY([estimate_id])
REFERENCES [dbo].[estimates] ([id])
GO
ALTER TABLE [dbo].[estimate_components] CHECK CONSTRAINT [estimate_components_estimate_id_fk]
GO
