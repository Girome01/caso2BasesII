USE bases2_caso1

-- ******************************************* END Point 3 *****************************************************************************

DROP PROCEDURE IF EXISTS [EndPoint3]
GO
CREATE PROCEDURE [dbo].[EndPoint3]
AS
	SELECT * FROM (
	
		SELECT part.nombre AS Partido, DATEPART(year, ent.postTime) AS Año, DATEPART(month, ent.postTime) AS Nombre_Mes, COUNT(*) * 100/SUM(COUNT(*)) OVER() AS Porc_Entregables,
		RANK() OVER
		(PARTITION BY DATEPART(year, ent.postTime) ORDER BY COUNT(*)) Position
		FROM Entregable AS ent
		INNER JOIN [Plan] pln ON pln.planId = ent.planId
		INNER JOIN Partido part ON part.partidoId = pln.partidoId 
		GROUP BY part.nombre, ent.postTime
	) t
	WHERE Position < 4;
GO