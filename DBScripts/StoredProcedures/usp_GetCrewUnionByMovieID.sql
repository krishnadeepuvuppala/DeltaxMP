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
