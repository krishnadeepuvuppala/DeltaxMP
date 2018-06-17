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
