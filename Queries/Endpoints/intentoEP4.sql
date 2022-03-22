USE bases2_caso1

DROP PROCEDURE IF EXISTS [EndPoint4]
GO
Create Procedure [dbo].[EndPoint4]
as
	WITH clasEnt(entId, Ranking, Tipo)
	AS
	(SELECT ent.entregableId entId, cEnt."rank" Ranking, 
			Tipo = case 
				WHEN ( cEnt."rank") < 67 THEN 'Insatisfecho' 
				WHEN ( cEnt."rank" >= 67) THEN 'Muy satisfecho' 
				Else 'Ninguno' END 
	FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId
	INNER JOIN Accion acc ON acc.accionId = ent.accionId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId)

	SELECT t.Partido, t.Porcentaje, Rank() OVER ( ORDER BY t.Porcentaje DESC ) Posicion, t.NotaMaxima FROM 
	( SELECT par.nombre Partido,
	( CONVERT(DECIMAL(6,2), COUNT(cEnt.entId) ) / CONVERT(DECIMAL(6,2), totPor.Total)*100 ) Porcentaje,
	MAX(cEnt.Ranking) NotaMaxima
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN clasEnt cEnt ON cEnt.entId = ent.entregableId
	INNER JOIN (
	SELECT par.partidoId, COUNT(*) Total
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId
	GROUP BY par.partidoId) as totPor ON totPor.partidoId = par.partidoId
	WHERE cEnt.Ranking >= 67
	GROUP BY par.nombre, totPor.Total) as t
GO

