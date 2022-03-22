USE bases2_caso1

DROP PROCEDURE IF EXISTS [EndPoint4]
GO
Create Procedure [dbo].[EndPoint4]
as
	WITH clasEnt(cantonId, Nombre, Ranking, Tipo)
	AS
	(SELECT can.cantonId cantonId, can.nombre Nombre, cEnt."rank" Ranking, 
			Tipo = case 
				WHEN ( cEnt."rank") < 34 THEN 'Insatisfecho' 
				WHEN ( cEnt."rank" >= 34 AND cEnt."rank" <= 66 ) THEN 'Medianamente satisfecho' 
				WHEN ( cEnt."rank" >= 67) THEN 'Muy satisfecho' 

				Else 'Ninguno' END 
	
	FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId)

	SELECT t.Partido, t.Porcentaje, Rank() OVER ( ORDER BY t.Porcentaje DESC ) Posicion, t.NotaMaxima 
	FROM ( SELECT par.nombre Partido,
	( CONVERT(DECIMAL(6,2), COUNT(cEnt.Tipo) ) / CONVERT(DECIMAL(6,2), AVG(totPor.Total))*100 ) Porcentaje,
	MAX(cEnt.Ranking) NotaMaxima
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN Accion acc ON acc.planId = pln.planId
	INNER JOIN clasEnt cEnt ON cEnt.cantonId = ent.cantonId
	INNER JOIN (
	SELECT par.partidoId, COUNT(cEnt.Tipo) Total
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN clasEnt cEnt ON cEnt.cantonId = ent.cantonId
	GROUP BY par.partidoId) as totPor ON totPor.partidoId = par.partidoId
	WHERE cEnt.Ranking >= 67
	GROUP BY par.nombre, cEnt.Tipo ) as t
GO
-- ****************************************************************************************************************
WITH clasEnt(cantonId, Nombre, Ranking, Tipo)
	AS
	(SELECT can.cantonId cantonId, can.nombre Nombre, cEnt."rank" Ranking, 
			Tipo = case 
				WHEN ( cEnt."rank") < 34 THEN 'Insatisfecho' 
				WHEN ( cEnt."rank" >= 34 AND cEnt."rank" <= 66 ) THEN 'Medianamente satisfecho' 
				WHEN ( cEnt."rank" >= 67) THEN 'Muy satisfecho' 

				Else 'Ninguno' END 
	
	FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId)

	SELECT t.Partido, t.Porcentaje, Rank() OVER ( ORDER BY t.Porcentaje DESC ) Posicion, t.NotaMaxima 
	FROM ( SELECT par.nombre Partido,
	( CONVERT(DECIMAL(6,2), COUNT(cEnt.Tipo) ) / CONVERT(DECIMAL(6,2), AVG(totPor.Total))*100 ) Porcentaje,
	MAX(cEnt.Ranking) NotaMaxima
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN Accion acc ON acc.planId = pln.planId
	INNER JOIN clasEnt cEnt ON cEnt.cantonId = ent.cantonId
	INNER JOIN (
	SELECT par.partidoId, COUNT(cEnt.Tipo) Total
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN clasEnt cEnt ON cEnt.cantonId = ent.cantonId
	GROUP BY par.partidoId) as totPor ON totPor.partidoId = par.partidoId
	WHERE cEnt.Ranking >= 67
	GROUP BY par.nombre, cEnt.Tipo ) as t;

	WITH clasEnt2(cantonId, Nombre, Ranking, Tipo)
	AS
	(SELECT can.cantonId cantonId, can.nombre Nombre, cEnt."rank" Ranking, 
			Tipo = case 
				WHEN ( cEnt."rank") < 34 THEN 'Insatisfecho' 
				WHEN ( cEnt."rank" >= 34 AND cEnt."rank" <= 66 ) THEN 'Medianamente satisfecho' 
				WHEN ( cEnt."rank" >= 67) THEN 'Muy satisfecho' 

				Else 'Ninguno' END 
	
	FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId)

	SELECT t.Partido, t.Porcentaje, Rank() OVER ( ORDER BY t.Porcentaje DESC ) Posicion, t.NotaMaxima 
	FROM ( SELECT par.nombre Partido,
	( CONVERT(DECIMAL(6,2), COUNT(cEnt.Tipo) ) / CONVERT(DECIMAL(6,2), AVG(totPor.Total))*100 ) Porcentaje,
	MAX(cEnt.Ranking) NotaMaxima
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN Accion acc ON acc.planId = pln.planId
	INNER JOIN clasEnt2 cEnt ON cEnt.cantonId = ent.cantonId
	INNER JOIN (
	SELECT par.partidoId, COUNT(cEnt.Tipo) Total
	FROM Partido par 
	INNER JOIN [Plan] pln ON pln.partidoId = par.partidoId
	INNER JOIN Entregable ent ON ent.planId = pln.planId
	INNER JOIN clasEnt2 cEnt ON cEnt.cantonId = ent.cantonId
	GROUP BY par.partidoId) as totPor ON totPor.partidoId = par.partidoId
	WHERE cEnt.Ranking >= 67
	GROUP BY par.nombre, cEnt.Tipo ) as t