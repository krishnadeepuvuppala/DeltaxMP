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
