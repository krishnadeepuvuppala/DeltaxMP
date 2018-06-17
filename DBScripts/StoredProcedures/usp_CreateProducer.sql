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
