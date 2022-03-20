 USE bases2_caso1


GO
CREATE TYPE entregableType AS TABLE
(
    kpiValue smallint,
	kpiType nvarchar(50),
	accionId int,
	fechaFinalizacion datetime,
	valorRef INT,
	ranking SMALLINT
)
GO

CREATE PROCEDURE [dbo].[EndPoint6]
	@Usuario NVARCHAR(50),
	@Plan NVARCHAR(100),
	@EntregablesType entregableType READONLY
AS 
BEGIN
	
	SET NOCOUNT ON -- no retorne metadatos
	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	DECLARE @UserId BIGINT
	DECLARE @CantonId SMALLINT
	DECLARE @PlanId INT
	DECLARE @fila INT
	DECLARE @totalFila INT
	DECLARE @LastId INT

	SELECT @UserId = us.usuarioId FROM Usuario us WHERE us.nombre =  TRIM(@Usuario) -- Conseguir el id del usuario

	IF (@UserID = 0)
        RAISERROR('%s - Error Number: %i', 
            @ErrorSeverity, @ErrorState, @Message, @CustomError)

	SELECT @CantonId = cUs.cantonId FROM cantonperusuario cUs WHERE cUs.usuarioId =  @UserId -- Conseguir el id del canton

	IF (@CantonId = NULL)
        RAISERROR('%s - Error Number: %i', 
            @ErrorSeverity, @ErrorState, @Message, @CustomError)

	SELECT @PlanId = plans.planId FROM [Plan] plans WHERE plans.titulo =  TRIM(@Plan) -- Conseguir el id del plan

	IF (@PlanId = NULL)
        RAISERROR('%s - Error Number: %i', 
            @ErrorSeverity, @ErrorState, @Message, @CustomError)

	SELECT @totalFila = COUNT(entType.accionId) FROM @EntregablesType entType
	-- operaciones de select que no tengan que ser bloqueadas
	-- tratar de hacer todo lo posible antes de q inice la transaccion
	
	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION		
	END
	
	BEGIN TRY
		SET @CustomError = 2001
		SET @fila = 1
		WHILE @fila <= @totalFila BEGIN
			
			MERGE Entregable AS ent
			USING (SELECT @PlanId, @CantonId, entType.kpiValue, entType.kpiType, GETDATE(), 
					CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('ent' + entType.kpiType) ) ),
					entType.accionId, entType.fechaFinalizacion 
					FROM @EntregablesType entType 
					WHERE entType.valorRef = @fila) as entDat 
			(planId, cantonId, kpiValue, kpiType, postTime, [checksum], accionId, fechaFinalizacion)  
			ON (ent.planId = entDat.planId AND ent.cantonId = entDat.cantonId AND ent.accionId = entDat.accionId)  
			WHEN MATCHED THEN
				UPDATE SET ent.planId = entDat.planId, ent.cantonId = entDat.cantonId, ent.kpiValue = entDat.kpiValue, 
				ent.kpiType = entDat.kpiType, ent.postTime =  GETDATE(), 
				ent.[checksum] = CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('ent' + entDat.kpiType) ) ), 
				ent.accionId = entDat.accionId, ent.fechaFinalizacion = entDat.fechaFinalizacion

			WHEN NOT MATCHED THEN 
				INSERT(planId, cantonId, kpiValue, kpiType, postTime, [checksum], accionId, fechaFinalizacion)
				VALUES(entDat.planId, entDat.cantonId, entDat.kpiValue, entDat.kpiType, GETDATE(), 
					CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('ent' + entDat.kpiType) ) ),
					entDat.accionId, entDat.fechaFinalizacion)
			;

			SELECT @LastId = ent.entregableId FROM Entregable ent 
			INNER JOIN @EntregablesType entType ON entType.valorRef = @fila
			WHERE
			ent.planId = @PlanId AND ent.cantonId = @CantonId AND ent.accionId = entType.accionId

			IF (@LastId = NULL)
				SET @LastId = (SELECT ent.entregableId FROM Entregable ent WHERE ent.entregableId = @@Identity)

			MERGE calificacionEntregables AS cEnt
			USING(SELECT @LastId, @UserId, entType.ranking, GETDATE(),
				CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('cal'+ CONVERT(nvarchar, @UserId+entType.ranking) )) )
				FROM @EntregablesType entType 
				WHERE entType.valorRef = @fila) as cEntDat
			(entregableId, usuarioId, [rank], posttime, [checksum])
			ON (cEnt.entregableId = cEntDat.entregableId AND cEnt.usuarioId = cEntDat.usuarioId)
			WHEN MATCHED THEN
				UPDATE SET cEnt.entregableId = cEntDat.entregableId, cEnt.usuarioId = cEntDat.usuarioId, 
				cEnt.[rank] = cEntDat.[rank], cEnt.posttime = GETDATE(), 
				cEnt.[checksum] = CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('cal'+ CONVERT(nvarchar, @UserId+cEntDat.[rank]) )) )
			WHEN NOT MATCHED THEN 
			INSERT (entregableId, usuarioId, [rank], posttime, [checksum])
			VALUES (cEntDat.entregableId, cEntDat.usuarioId, cEntDat.[rank], 
			GETDATE(), CONVERT( VARBINARY(150),HASHBYTES('SHA2_256', ('cal'+ CONVERT(nvarchar, @UserId+cEntDat.[rank]) )) ))
			;
			
			SET @fila = @fila + 1
		END
		IF @InicieTransaccion=1 BEGIN
			COMMIT
			SELECT '200 OKEY'
		END
	END TRY
	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()
		
		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i', 
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH	
END
RETURN 0
GO

/*
-- Se declara una variable para la tabla TVP
DECLARE @TVP AS entregableType;

-- se insertan los daros de los entregables en la tabla TVP
INSERT INTO @TVP (kpiValue, kpiType, accionId,fechaFinalizacion,valorRef,ranking)
VALUES
(1, 'impuestos', 2, GETDATE(), 1, 90)

INSERT INTO @TVP (kpiValue, kpiType, accionId,fechaFinalizacion,valorRef,ranking)
VALUES
(1, 'impuestos', 1, GETDATE(), 2, 90)

SELECT * FROM Entregable
SELECT * FROM calificacionEntregables
-- el SP recibe el nombre del usuario, nombre del plan y los datos de los entregables en una tabla TVP
EXEC enPoint6 'Nombre374008','Plan PLN',@TVP
SELECT * FROM Entregable*/
