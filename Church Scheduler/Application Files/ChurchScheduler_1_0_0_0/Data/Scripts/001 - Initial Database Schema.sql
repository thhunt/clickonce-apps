/****** Object:  Table [dbo].[Duty]    Script Date: 1/21/2024 2:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Duty](
	[ID] [uniqueidentifier] NOT NULL,
	[ServiceID] [uniqueidentifier] NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[NumberOfPositions] [tinyint] NOT NULL,
	[SortOrder] [tinyint] NOT NULL,
	[PrintCode] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Duty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Personel]    Script Date: 1/21/2024 2:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Personel](
	[ID] [uniqueidentifier] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DisplayName]  AS (([FirstName]+' ')+[LastName]),
	[SortName]  AS (([LastName]+', ')+[FirstName]),
	[Active] [bit] NOT NULL,
	[LastScheduleDate] [date] NULL,
 CONSTRAINT [PK_Personel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonelDuty]    Script Date: 1/21/2024 2:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonelDuty](
	[ID] [uniqueidentifier] NOT NULL,
	[PersonelID] [uniqueidentifier] NOT NULL,
	[DutyID] [uniqueidentifier] NOT NULL,
	[DateLastAssigned] [date] NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_PersonelDuty] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 1/21/2024 2:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[DayOfWeek] [varchar](50) NOT NULL,
	[DayOfWeekNumber]  AS (case [DayOfWeek] when 'Sunday' then (1) when 'Monday' then (2) when 'Tuesday' then (3) when 'Wednesday' then (4) when 'Thursday' then (5) when 'Friday' then (6) when 'Saturday' then (7)  end),
	[SortOrder] [tinyint] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Service] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Duty] ADD  CONSTRAINT [DF__ServiceDuty__ID__5DCAEF64]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Duty] ADD  CONSTRAINT [DF__ServiceDu__Numbe__5EBF139D]  DEFAULT ((1)) FOR [NumberOfPositions]
GO
ALTER TABLE [dbo].[Duty] ADD  CONSTRAINT [DF__Duty__SortOrder__2739D489]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Duty] ADD  CONSTRAINT [DF__ServiceDu__Activ__5FB337D6]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Personel] ADD  CONSTRAINT [DF__Personel__ID__60A75C0F]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Personel] ADD  CONSTRAINT [DF__Personel__Active__619B8048]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[PersonelDuty] ADD  CONSTRAINT [DF__tmp_ms_xx_Pe__ID__693CA210]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[PersonelDuty] ADD  CONSTRAINT [DF__tmp_ms_xx__Activ__6A30C649]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Service] ADD  CONSTRAINT [DF__Service__ID__6477ECF3]  DEFAULT (newid()) FOR [ID]
GO
ALTER TABLE [dbo].[Service] ADD  CONSTRAINT [DF__Service__SortOrd__14270015]  DEFAULT ((1)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Service] ADD  CONSTRAINT [DF__Service__Active__656C112C]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Duty]  WITH CHECK ADD  CONSTRAINT [FK_Duty_Service] FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Service] ([ID])
GO
ALTER TABLE [dbo].[Duty] CHECK CONSTRAINT [FK_Duty_Service]
GO
ALTER TABLE [dbo].[PersonelDuty]  WITH CHECK ADD  CONSTRAINT [FK_ServiceDutyPersonel_Personel] FOREIGN KEY([PersonelID])
REFERENCES [dbo].[Personel] ([ID])
GO
ALTER TABLE [dbo].[PersonelDuty] CHECK CONSTRAINT [FK_ServiceDutyPersonel_Personel]
GO
ALTER TABLE [dbo].[PersonelDuty]  WITH CHECK ADD  CONSTRAINT [FK_ServiceDutyPersonel_ServiceDuty] FOREIGN KEY([DutyID])
REFERENCES [dbo].[Duty] ([ID])
GO
ALTER TABLE [dbo].[PersonelDuty] CHECK CONSTRAINT [FK_ServiceDutyPersonel_ServiceDuty]
GO
ALTER TABLE [dbo].[Service]  WITH CHECK ADD  CONSTRAINT [CK_Service_DayOfWeek] CHECK  (([DayOfWeek]='Saturday' OR [DayOfWeek]='Friday' OR [DayOfWeek]='Thursday' OR [DayOfWeek]='Wednesday' OR [DayOfWeek]='Tuesday' OR [DayOfWeek]='Monday' OR [DayOfWeek]='Sunday'))
GO
ALTER TABLE [dbo].[Service] CHECK CONSTRAINT [CK_Service_DayOfWeek]
GO
/****** Object:  StoredProcedure [dbo].[PR_BuildScheduleSelectionPool]    Script Date: 1/21/2024 2:08:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------
-- Build the selection pool
-------------------------------------------------

CREATE PROCEDURE [dbo].[PR_BuildScheduleSelectionPool]
(
	@WeekOfDate date
)

AS

SET @WeekOfDate = DATEADD(DAY, (DATEPART(WEEKDAY, @WeekOfDate) * -1) + 1, @WeekOfDate)

;WITH c_PersonelDuties AS
(
	SELECT
		PersonelDuty.ID,
		COUNT(*) OVER (PARTITION BY PersonelDuty.DutyID) AS TotalPersonelForDuty,
		COUNT(*) OVER (PARTITION BY PersonelDuty.PersonelID) AS TotalDutiesForPersonel
	FROM
		dbo.PersonelDuty
)
SELECT
	NEWID() AS ID,
	PersonelDuty.ID AS PersonelDutyID,

	Duty.ServiceID,
	Service.Name AS ServiceName,
	DATEADD(DAY, Service.DayOfWeekNumber - 1, @WeekOfDate) AS ServiceDate,
	Service.SortOrder AS ServiceSortOrder,
	CAST(0 AS bit) AS AssignedForSameServiceDate,

	PersonelDuty.DutyID,
	Duty.Description AS DutyDescription,
	Duty.SortOrder AS DutySortOrder,
	Duty.NumberOfPositions AS DutyNumberOfPositions,
	Duty.PrintCode AS DutyPrintCode,

	PersonelDuty.PersonelID,
	Personel.DisplayName AS PersonelDisplayName,
	Personel.SortName AS PersonelSortName,

	PersonelDuty.DateLastAssigned,
	Personel.LastScheduleDate,

	c_PersonelDuties.TotalDutiesForPersonel,
	c_PersonelDuties.TotalPersonelForDuty,
	
	DENSE_RANK() OVER (ORDER BY c_PersonelDuties.TotalPersonelForDuty, Service.SortOrder, Duty.SortOrder, PersonelDuty.DutyID) AS DutyPriority,
	0 AS PersonelAssignmentCount,
	ROW_NUMBER() OVER (ORDER BY PersonelDuty.DateLastAssigned, c_PersonelDuties.TotalDutiesForPersonel, Personel.LastScheduleDate, Personel.SortName) AS PersonelPriority
FROM
	c_PersonelDuties
INNER JOIN
	dbo.PersonelDuty ON PersonelDuty.ID = c_PersonelDuties.ID
INNER JOIN
	dbo.Personel ON Personel.ID = PersonelDuty.PersonelID
INNER JOIN
	dbo.Duty ON Duty.ID = PersonelDuty.DutyID
INNER JOIN
	dbo.Service ON Service.ID = Duty.ServiceID
WHERE
	PersonelDuty.Active = 1
	AND
	Personel.Active = 1
	AND
	Duty.Active = 1
	AND
	Service.Active = 1
ORDER BY
	DutyPriority,
	PersonelAssignmentCount,
	PersonelPriority
GO
