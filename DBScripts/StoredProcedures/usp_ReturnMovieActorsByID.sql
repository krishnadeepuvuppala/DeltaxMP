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