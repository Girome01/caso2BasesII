USE bases2_caso1

-- ******************************************* END Point 3 ****************************************************************************

CREATE FULLTEXT CATALOG FullTextCatalog
CREATE UNIQUE INDEX ui_Part ON Partido(partidoId)
CREATE FULLTEXT INDEX ON Partido (nombre) KEY INDEX ui_Part ON FullTextCatalog WITH CHANGE_TRACKING AUTO


DROP PROCEDURE IF EXISTS [EndPoint3]
GO
CREATE PROCEDURE [dbo].[EndPoint3] @palabras NVARCHAR(100)
AS
	SELECT * FROM (
		SELECT t1.Partido AS Partido, DATEPART(year, t2.Time) AS Año, DATEPART(month, t2.Time) AS Nombre_Mes, t1.Total * 100/t3.EntTOtal AS Porc_Entregables,
		RANK() OVER
		(PARTITION BY DATEPART(year, t2.Time) ORDER BY Total) AS Position
		FROM 
		(
			SELECT part.nombre AS Partido, COUNT(*) AS Total
			FROM Entregable AS ent
			LEFT JOIN [Plan] pln ON pln.planId = ent.planId
			LEFT JOIN Partido part ON part.partidoId = pln.partidoId
			WHERE FREETEXT(part.nombre, @palabras)
			GROUP BY part.nombre
		) t1
		LEFT JOIN
		(
			SELECT part.nombre AS Partido, ent.postTime AS Time
			FROM Entregable AS ent
			LEFT JOIN [Plan] pln ON pln.planId = ent.planId
			LEFT JOIN Partido part ON part.partidoId = pln.partidoId 
			GROUP BY part.nombre, ent.postTime
		) t2
		ON (t1.Partido = t2.Partido)
		LEFT JOIN
		(
			SELECT COUNT(*) EntTOtal
			FROM Entregable
		) t3
		ON (t1.Partido = t2.Partido)
	) tot
	WHERE Position < 4
GO


EXEC EndPoint3 @palabras = 'UNIDAD'