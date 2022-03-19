USE bases2_caso1

-- ******************************************* END Point 2 *****************************************************************************

DROP PROCEDURE IF EXISTS [EndPoint2]
GO
CREATE PROCEDURE [dbo].[EndPoint2] @partido NVARCHAR(100), @accion smallint
AS
	SELECT partido AS Partido, accion AS Accion, [1] AS Tercio_1, [2] AS Tercio_2, [3] AS Tercio_3
	FROM 
	(
		SELECT part.nombre AS partido, acc.accionId AS accion, ent.cantonId AS cantones, ent.satisfaccion AS totSatisfaccion,
		((CAST(ent.satisfaccion*100 AS INT))%3)+1 AS satisfaccion FROM Accion AS acc
		LEFT JOIN [Plan] pln ON pln.planId = acc.planId
		LEFT JOIN Partido part ON part.partidoId = pln.partidoId
		LEFT JOIN Entregable ent ON ent.accionId = acc.accionId
		LEFT JOIN Canton cant ON cant.cantonId = ent.cantonId
		WHERE part.nombre = @partido AND acc.accionId = @accion
		GROUP BY part.nombre, acc.accionId, ent.cantonId, ent.satisfaccion
	) AS datos
	PIVOT
	(
		COUNT(cantones) 
		FOR satisfaccion IN ([1], [2], [3])
	) AS PivotTable;
GO

EXEC EndPoint2 @partido = 'Partido Liberacion Nacional', @accion = 3

