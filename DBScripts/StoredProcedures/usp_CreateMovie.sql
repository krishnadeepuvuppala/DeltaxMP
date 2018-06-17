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
