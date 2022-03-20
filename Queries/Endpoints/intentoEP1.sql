USE bases2_caso1

-- ******************************************* END Point 1 *****************************************************************************

DROP PROCEDURE IF EXISTS [EndPoint1]
GO
Create Procedure [dbo].[EndPoint1]
as
	SELECT can.nombre Canton, COUNT(ent.entregableId) Primeros100Dias FROM Entregable ent
	INNER JOIN dbo.Canton can ON can.cantonId = ent.cantonId
	INNER JOIN dbo."Plan" plans ON plans.planId = ent.planId
	WHERE ent.fechaFinalizacion <= DATEADD(DD, 100, plans.fechaInicio)
	GROUP BY can.nombre
	EXCEPT
	SELECT can.nombre Canton, COUNT(ent.entregableId) Primeros100Dias FROM Entregable ent
	INNER JOIN dbo.Canton can ON can.cantonId = ent.cantonId
	INNER JOIN dbo."Plan" plans ON plans.planId = ent.planId
	WHERE ent.fechaFinalizacion >= DATEADD(DD, -100,Getdate())
	GROUP BY can.nombre
GO

-- ***********************************************************************************************************************************************************************

EXEC EndPoint1;

SELECT par.nombre partido, can.nombre nomCanton, ent.entregableId EntregableId, acc.accionId Accion FROM Entregable as ent
INNER JOIN Canton can ON can.cantonId = ent.cantonId
INNER JOIN Accion acc ON acc.accionId = ent.accionId
INNER JOIN "Plan" plans ON plans.planID = acc.planID
INNER JOIN Partido par ON par.partidoId = plans.PartidoId
INNER JOIN calificacionEntregables cent ON cent.entregableId = ent.entregableId
WHERE par.partidoId = 4 AND 12 = acc.accionId
GROUP BY can.nombre