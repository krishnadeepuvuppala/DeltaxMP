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
