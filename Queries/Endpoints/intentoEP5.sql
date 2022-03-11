USE bases2_caso1


-- ***************************************************************************************************************************************************************************
DROP PROCEDURE IF EXISTS [EndPoint5]
GO
Create Procedure [dbo].[EndPoint5]
as
	SELECT Partido, ISNULL(Canton, '"Sumarizado"') Canton, ISNULL([Insatisfecho], 0) Insatisfecho, 
			ISNULL([Medianamente satisfecho],0) [Medianamente satisfecho],ISNULL([Muy satisfecho],0) [Muy satisfecho] FROM
	(SELECT cTotal.Partido Partido, datos.Nombre Canton, datos.Tipo, (  CONVERT(DECIMAL(6,2), 
		(COUNT(datos.Ranking)) / CONVERT(DECIMAL(6,2), AVG(cTotal.Total)))*100 ) Porcentaje FROM
	(SELECT can.cantonId cantonId, cEnt."rank" Ranking, can.nombre Nombre, 
		Tipo = case 
			WHEN ( cEnt."rank") < 34 THEN 'Insatisfecho' 
			WHEN ( cEnt."rank" >= 34 AND cEnt."rank" <= 66 ) THEN 'Medianamente satisfecho' 
			WHEN ( cEnt."rank" >= 67) THEN 'Muy satisfecho' 

			Else 'Ninguno' END 
	
		FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId)
	as datos
	INNER JOIN (
	SELECT par.nombre Partido, can.cantonId cantonId, COUNT(cEnt.entregableId) Total  FROM Canton can
	INNER JOIN Entregable ent ON ent.cantonId = can.cantonId 
	INNER JOIN calificacionEntregables cEnt ON cEnt.entregableId = ent.entregableId
	INNER JOIN "Plan" plans ON plans.planId = ent.planId
	INNER JOIN Partido par ON par.partidoId = plans.partidoId
	GROUP BY can.cantonId, par.nombre) as cTotal ON cTotal.cantonId = datos.cantonId
	GROUP BY ROLLUP(datos.Tipo,  datos.Nombre ),cTotal.Partido) as Result
	PIVOT
	(
		AVG(Porcentaje)
		FOR Tipo IN ([Insatisfecho],[Medianamente satisfecho],[Muy satisfecho])
	) as pivotTable
	ORDER BY Partido
GO
