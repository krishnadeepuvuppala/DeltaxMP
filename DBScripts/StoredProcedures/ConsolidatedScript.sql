USE [MoviePortal]
GO

/****** Object:  Table [dbo].[PRODUCERS]    Script Date: 17/06/2018 20:07:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PRODUCERS](
	[PRODUCER_ANID] [int] IDENTITY(1,1) NOT NULL,
	[PRODUCER_NAME] [nvarchar](300) NULL,
	[PRODUCER_GENDER] [char](1) NULL,
	[PRODUCER_DOB] [date] NULL,
	[PRODUCER_BIO] [nvarchar](max) NULL,
	[CREATED_BY] [nvarchar](300) NULL,
	[CREATED_DTTM] [datetime] NULL,
	[UPDATED_BY] [nvarchar](300) NULL,
	[UPDATED_DTTM] [datetime] NULL,
 CONSTRAINT [PK_PRODUCERS] PRIMARY KEY CLUSTERED 
(
	[PRODUCER_ANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-------------------------------------------------------------------------------------------------

USE [MoviePortal]
GO

/****** Object:  Table [dbo].[MOVIES]    Script Date: 17/06/2018 20:07:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MOVIES](
	[MOVIE_ANID] [int] IDENTITY(1,1) NOT NULL,
	[MOVIE_NAME] [nvarchar](200) NULL,
	[MOVIE_YOR] [nvarchar](50) NULL,
	[MOVIE_PLOT] [nvarchar](max) NULL,
	[MOVIE_POSTER] [nvarchar](max) NULL,
	[CREATED_BY] [nvarchar](300) NULL,
	[CREATED_DTTM] [datetime] NULL,
	[UPDATED_BY] [nvarchar](300) NULL,
	[UPDATED_DTTM] [datetime] NULL,
 CONSTRAINT [PK_MOVIES] PRIMARY KEY CLUSTERED 
(
	[MOVIE_ANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


----------------------------------------------------------------------------------------------------
USE [MoviePortal]
GO

/****** Object:  Table [dbo].[CREW_UNION]    Script Date: 17/06/2018 20:07:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CREW_UNION](
	[CREWUNION_ANID] [int] IDENTITY(1,1) NOT NULL,
	[MOVIE_ANID] [int] NULL,
	[ACTOR_ANIDS] [nvarchar](max) NULL,
	[PRODUCER_ANID] [int] NULL,
	[CREATED_BY] [nvarchar](300) NULL,
	[CREATED_DTTM] [datetime] NULL,
	[UPDATED_BY] [nvarchar](300) NULL,
	[UPDATED_DTTM] [datetime] NULL,
 CONSTRAINT [PK_CREW_UNION] PRIMARY KEY CLUSTERED 
(
	[CREWUNION_ANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-------------------------------------------------------------------------------------------------------------------------------------

USE [MoviePortal]
GO

/****** Object:  Table [dbo].[ACTORS]    Script Date: 17/06/2018 20:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ACTORS](
	[ACTOR_ANID] [int] IDENTITY(1,1) NOT NULL,
	[ACTOR_NAME] [nvarchar](300) NULL,
	[ACTOR_GENDER] [char](1) NULL,
	[ACTOR_DOB] [date] NULL,
	[ACTOR_BIO] [varchar](max) NULL,
	[CREATED_BY] [nvarchar](300) NULL,
	[CREATED_DTTM] [datetime] NULL,
	[UPDATED_BY] [nvarchar](300) NULL,
	[UPDATED_DTTM] [datetime] NULL,
 CONSTRAINT [PK_ACTORS] PRIMARY KEY CLUSTERED 
(
	[ACTOR_ANID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


-----------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_UpdateMovie')
BEGIN
DROP Procedure [dbo].[usp_UpdateMovie]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_UpdateMovie]

(
	 @MOVIE_ANID		INT
	,@CREW_ANID			INT
	,@ACTORS			NVARCHAR(4000)
	,@PRODUCER_ANID		INT
	,@MOVIE_NAME		NVARCHAR(400)
	,@UPDATED_BY		NVARCHAR(600)
	,@MOVIE_YOR			NVARCHAR(100)
	,@MOVIE_PLOT		NVARCHAR(MAX)
	,@MOVIE_POSTER		NVARCHAR(MAX)
)

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
		IF(LEN(@MOVIE_NAME) >0)
		BEGIN
			UPDATE MOVIES  SET MOVIE_NAME = @MOVIE_NAME,MOVIE_YOR=@MOVIE_YOR,MOVIE_PLOT=@MOVIE_PLOT,MOVIE_POSTER=@MOVIE_POSTER,UPDATED_BY=@UPDATED_BY, UPDATED_DTTM=GETDATE() WHERE MOVIE_ANID = @MOVIE_ANID 
		END

		UPDATE CREW_UNION SET ACTOR_ANIDS = @ACTORS, PRODUCER_ANID=@PRODUCER_ANID, UPDATED_BY=@UPDATED_BY, UPDATED_DTTM=GETDATE() WHERE CREWUNION_ANID =@CREW_ANID AND MOVIE_ANID = @MOVIE_ANID

		SELECT @@ROWCOUNT
		
END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_UpdateMovie] TO PUBLIC

GO
--------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_ReturnProducerList')
BEGIN
DROP Procedure [dbo].[usp_ReturnProducerList]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_ReturnProducerList]

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
	
SELECT   P.PRODUCER_ANID
		,P.PRODUCER_NAME

FROM PRODUCERS P

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_ReturnProducerList] TO PUBLIC

GO
----------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_ReturnMovieList')
BEGIN
DROP Procedure [dbo].[usp_ReturnMovieList]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_ReturnMovieList]

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
SELECT 
	   M.MOVIE_NAME AS Name
	  ,M.MOVIE_YOR AS Year
	  ,CU.ACTOR_ANIDS AS Actors
	  ,P.PRODUCER_NAME AS Producer
	  ,M.MOVIE_POSTER AS Poster
	  ,M.MOVIE_ANID AS Actions
	   FROM MOVIES M  INNER JOIN CREW_UNION CU ON M.MOVIE_ANID = CU.MOVIE_ANID
	  INNER JOIN PRODUCERS P ON CU.PRODUCER_ANID = P.PRODUCER_ANID

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_ReturnMovieList] TO PUBLIC

GO
--------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_ReturnMovieActorsByID')
BEGIN
DROP Procedure [dbo].[usp_ReturnMovieActorsByID]
END


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_ReturnMovieActorsByID]
(
		@ACTORS_IDS     NVARCHAR(MAX)
)
AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error
		,@sbSQL					NVARCHAR(max) =''
		



BEGIN

	
SELECT   A.ACTOR_ANID
		,A.ACTOR_NAME

FROM ACTORS A WHERE A.ACTOR_ANID IN (@ACTORS_IDS)

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_ReturnMovieActorsByID] TO PUBLIC

GO
--------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_ReturnActorsList')
BEGIN
DROP Procedure [dbo].[usp_ReturnActorsList]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_ReturnActorsList]

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
	
SELECT   A.ACTOR_ANID
		,A.ACTOR_NAME

FROM ACTORS A 

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_ReturnActorsList] TO PUBLIC

GO
-------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_GetCrewUnionByMovieID')
BEGIN
DROP Procedure [dbo].[usp_GetCrewUnionByMovieID]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_HELPTEXT [usp_GetCrewUnionByMovieID] 
/*
EXEC [usp_GetCrewUnionByMovieID] 1
*/

CREATE Procedure [dbo].[usp_GetCrewUnionByMovieID]
(
		@MOVIE_ANID     INT
)
AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
SELECT M.MOVIE_ANID,
	   M.MOVIE_NAME,
	   M.MOVIE_PLOT,
	   M.MOVIE_POSTER,
	   M.MOVIE_YOR,
	   CU.CREWUNION_ANID,
	   P.PRODUCER_ANID,
	   P.PRODUCER_NAME,
	   CU.ACTOR_ANIDS

	FROM CREW_UNION CU INNER JOIN MOVIES M ON  M.MOVIE_ANID=CU.MOVIE_ANID 
	INNER JOIN PRODUCERS P ON P.PRODUCER_ANID = CU.PRODUCER_ANID WHERE CU.MOVIE_ANID = @MOVIE_ANID

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_GetCrewUnionByMovieID] TO PUBLIC

GO
---------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_CreateProducer')
BEGIN
DROP Procedure [dbo].[usp_CreateProducer]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[usp_CreateProducer]

(
	 @PRODUCER_NAME			NVARCHAR(600)
	,@PRODUCER_GENDER		CHAR(1)
	,@PRODUCER_DOB			NVARCHAR(500)
	,@PRODUCER_BIO			VARCHAR(4000)
	,@CREATED_BY			NVARCHAR(600)
)

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
		INSERT INTO [dbo].[PRODUCERS]
           ([PRODUCER_NAME]
           ,[PRODUCER_GENDER]
           ,[PRODUCER_DOB]
           ,[PRODUCER_BIO]
           ,[CREATED_BY]
           ,[CREATED_DTTM])

     VALUES
           (@PRODUCER_NAME
           ,@PRODUCER_GENDER
           ,@PRODUCER_DOB
           ,@PRODUCER_BIO
           ,@CREATED_BY
		   ,GETDATE())

		   SELECT @@IDENTITY
END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_CreateProducer] TO PUBLIC

GO
----------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_CreateMovie')
BEGIN
DROP Procedure [dbo].[usp_CreateMovie]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[usp_CreateMovie]

(
	 @MOVIE_NAME			NVARCHAR(400)
	,@MOVIE_YOR				NVARCHAR(100)
	,@MOVIE_PLOT			NVARCHAR(4000)
	,@MOVIE_POSTER			NVARCHAR(MAX)
	,@PRODUCER_ANID			INT
	,@ACTORS_ANIDS			NVARCHAR(MAX)
	,@CREATED_BY			NVARCHAR(600)
)

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error
		,@MOVIE_ANID			INT = 0

BEGIN

	
		INSERT INTO [dbo].[MOVIES]
           ([MOVIE_NAME]
           ,[MOVIE_YOR]
           ,[MOVIE_PLOT]
           ,[MOVIE_POSTER]
           ,[CREATED_BY]
           ,[CREATED_DTTM])
		VALUES
           (@MOVIE_NAME
           ,@MOVIE_YOR
           ,@MOVIE_PLOT
           ,@MOVIE_POSTER
           ,@CREATED_BY
           ,GETDATE())
		   
	 SET @MOVIE_ANID = (SELECT TOP 1 MOVIE_ANID FROM MOVIES ORDER BY 1 DESC)

	 IF(@MOVIE_ANID>0)
	 BEGIN

		INSERT INTO [dbo].[CREW_UNION]
           ([MOVIE_ANID]
           ,[ACTOR_ANIDS]
           ,[PRODUCER_ANID]
           ,[CREATED_BY]
           ,[CREATED_DTTM])

     VALUES
           (@MOVIE_ANID
           ,@ACTORS_ANIDS
           ,@PRODUCER_ANID
           ,@CREATED_BY
           ,GETDATE())
		
	 END

	 SELECT @@IDENTITY
		

END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_CreateMovie] TO PUBLIC

GO
----------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM MoviePortal.sys.objects WHERE type = 'P' AND name = 'usp_CreateActor')
BEGIN
DROP Procedure [dbo].[usp_CreateActor]
END

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[usp_CreateActor]

(
	 @ACTOR_NAME		NVARCHAR(600)
	,@ACTOR_GENDER		CHAR(1)
	,@ACTOR_DOB			NVARCHAR(500)
	,@ACTOR_BIO			VARCHAR(MAX)
	,@CREATED_BY		NVARCHAR(600)
)

AS

BEGIN
SET NOCOUNT ON

DECLARE  
		 @ErrMsg				NVARCHAR(510) --
		,@ErrorSeverity			INT --16 if business error

BEGIN

	
		INSERT INTO [dbo].[ACTORS]
           ([ACTOR_NAME]
           ,[ACTOR_GENDER]
           ,[ACTOR_DOB]
           ,[ACTOR_BIO]
           ,[CREATED_BY]
           ,[CREATED_DTTM])

     VALUES
           (@ACTOR_NAME
           ,@ACTOR_GENDER
           ,@ACTOR_DOB
           ,@ACTOR_BIO
           ,@CREATED_BY
		   ,GETDATE())

		   SELECT @@IDENTITY
END
GOTO SUCCESS

SUCCESS:
RETURN 1
CRASH:
RAISERROR (@ErrMsg, @ErrorSeverity, 1) WITH NOWAIT
END
GO
GRANT EXEC ON [dbo].[usp_CreateActor] TO PUBLIC

GO
