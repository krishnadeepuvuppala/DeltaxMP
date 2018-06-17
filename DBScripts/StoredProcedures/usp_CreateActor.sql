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
