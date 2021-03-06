USE [JWGL]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 04/26/2016 14:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[Sno] [nchar](10) NOT NULL,
	[Sname] [char](20) NULL,
	[Ssex] [char](2) NULL,
	[Sage] [tinyint] NULL,
	[Sdept] [char](20) NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY NONCLUSTERED 
(
	[Sno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000013   ', N'葛波                ', N'女', 17, N'计算机              ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000112   ', N'顾芳                ', N'女', 19, N'管理                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000113   ', N'姜凡                ', N'男', 19, N'管理                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000011   ', N'李峰                ', N'男', 18, N'计算机              ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000311   ', N'欧阳奋进            ', N'男', 22, N'外语                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000211   ', N'欧阳倩              ', N'女', 22, N'数学                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000012   ', N'王林                ', N'男', 19, N'计算机              ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000114   ', N'叶想                ', N'男', 18, N'管理                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000111   ', N'张大民              ', N'男', 18, N'管理                ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000312   ', N'石磊                ', N'男', 18, N'计算机              ')
INSERT [dbo].[Student] ([Sno], [Sname], [Ssex], [Sage], [Sdept]) VALUES (N'2000313   ', N'金鑫                ', N'男', 18, N'计算机              ')
/****** Object:  Table [dbo].[SC]    Script Date: 04/26/2016 14:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SC](
	[Sno] [nchar](10) NOT NULL,
	[Cno] [nchar](10) NOT NULL,
	[Grade] [tinyint] NULL,
 CONSTRAINT [PK_SC] PRIMARY KEY CLUSTERED 
(
	[Sno] ASC,
	[Cno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000011   ', N'1024      ', 90)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000011   ', N'1156      ', 55)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'1024      ', 88)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'1128      ', 90)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'1136      ', 78)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'1137      ', 66)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'1156      ', 80)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'2008      ', 88)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'2013      ', 78)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'2118      ', 89)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000012   ', N'2120      ', 80)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000013   ', N'1024      ', 85)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000013   ', N'1136      ', 90)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000013   ', N'1156      ', 89)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000111   ', N'1156      ', 93)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000112   ', N'1137      ', 66)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000112   ', N'1156      ', 88)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000113   ', N'1137      ', 89)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000113   ', N'1156      ', 60)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000114   ', N'1024      ', NULL)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000211   ', N'1136      ', 88)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000211   ', N'1137      ', 58)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000211   ', N'1156      ', 75)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000311   ', N'1024      ', 80)
INSERT [dbo].[SC] ([Sno], [Cno], [Grade]) VALUES (N'2000311   ', N'1156      ', 77)
/****** Object:  Table [dbo].[Course]    Script Date: 04/26/2016 14:53:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[Cno] [nchar](10) NOT NULL,
	[Cname] [nvarchar](32) NOT NULL,
	[Cpno] [nchar](10) NULL,
	[Ccredit] [tinyint] NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[Cno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'1024      ', N'数据库原理     ', N'1136      ', 4)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'1128      ', N'高等数学      ', NULL, 6)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'1136      ', N'离散数学      ', N'1128      ', 4)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'1137      ', N'管理学       ', NULL, 4)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'1156      ', N'英语        ', NULL, 6)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'2008      ', N'DB_Design', NULL, 4)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'2013      ', N'DB_DBMS Design', NULL, 4)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'2118      ', N'DB_Programing', NULL, 2)
INSERT [dbo].[Course] ([Cno], [Cname], [Cpno], [Ccredit]) VALUES (N'2120      ', N'DB*Design', NULL, 2)
