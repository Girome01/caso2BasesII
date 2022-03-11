USE bases2_caso1

-- ******************************************* END Point 2 *****************************************************************************

DROP PROCEDURE IF EXISTS [EndPoint2]
GO
CREATE PROCEDURE [dbo].[EndPoint2]
AS
	SELECT partido AS Partido, accion AS Accion, [1] AS Tercio_1, [2] AS Tercio_2, [3] AS Tercio_3
	FROM 
	(
		SELECT part.nombre AS partido, acc.accionId AS accion, ent.cantonId AS cantones, ent.satisfaccion AS totSatisfaccion,
		DENSE_RANK() OVER
		(ORDER BY ent.satisfaccion DESC) AS satisfaccion FROM Accion AS acc
		INNER JOIN [Plan] pln ON pln.planId = acc.planId
		INNER JOIN Partido part ON part.partidoId = pln.partidoId
		INNER JOIN Entregable ent ON ent.accionId = acc.accionId
		INNER JOIN Canton cant ON cant.cantonId = ent.cantonId
		GROUP BY part.nombre, acc.accionId, ent.cantonId, ent.satisfaccion
	) AS datos
	PIVOT
	(
		COUNT(cantones) 
		FOR satisfaccion IN ([1], [2], [3])
	) AS PivotTable;
GO


-- ************************************************************************************************************************

SELECT partido AS Partido, accion AS Accion, [1] AS Tercio_1, [2] AS Tercio_2, [3] AS Tercio_3
	FROM 
	(
		SELECT part.nombre AS partido, acc.accionId AS accion, ent.cantonId AS cantones, ent.satisfaccion AS totSatisfaccion,
		CASE
			WHEN ent.satisfaccion < 0.33 THEN 1
			WHEN ent.satisfaccion BETWEEN 0.33 AND 0.66 THEN 2
			ELSE 3
		END AS satisfaccion FROM Accion AS acc
		INNER JOIN [Plan] pln ON pln.planId = acc.planId
		INNER JOIN Partido part ON part.partidoId = pln.partidoId
		INNER JOIN Entregable ent ON ent.accionId = acc.accionId
		INNER JOIN Canton cant ON cant.cantonId = ent.cantonId
		GROUP BY part.nombre, acc.accionId, ent.cantonId, ent.satisfaccion
	) AS datos
	PIVOT
	(
		COUNT(cantones) 
		FOR satisfaccion IN ([1], [2], [3])
	) AS PivotTable;