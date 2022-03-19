use bases2_caso1;

-- PARTIDO
INSERT INTO Partido (nombre, bandera, fechaCreacion)
VALUES 
('Partido Liberacion Nacional', 100000, GETDATE()),
('Partido Accion Ciudadana', 100001, GETDATE()),
('Partido Unidad Social Cristiana', 100002, GETDATE()),
('Frente Amplio', 100003, GETDATE()),
('Restauracion Nacional', 100004, GETDATE());

-- PLAN
INSERT INTO [Plan] (titulo, descripcion, partidoId, fechaInicio, fechaFinaliza)
VALUES 
('Plan 1 PLN', 'Plan 1 de gobierno del Partido Liberacion Nacional.', 1, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 2 PLN', 'Plan 2 de gobierno del Partido Liberacion Nacional.', 1, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 3 PLN', 'Plan 3 de gobierno del Partido Liberacion Nacional.', 1, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 1 PAC', 'Plan 1 de gobierno del Partido Accion Ciudadana.', 2, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 2 PAC', 'Plan 2 de gobierno del Partido Accion Ciudadana.', 2, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 3 PAC', 'Plan 3 de gobierno del Partido Accion Ciudadana.', 2, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 1 PUSC', 'Plan 1 de gobierno del Partido Unidad Social Cristiana.', 3, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 2 PUSC', 'Plan 2 de gobierno del Partido Unidad Social Cristiana.', 3, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 3 PUSC', 'Plan 3 de gobierno del Partido Unidad Social Cristiana.', 3, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 1 FA', 'Plan 1 de gobierno del Frente Amplio.', 4, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 2 FA', 'Plan 2 de gobierno del Frente Amplio.', 4, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 3 FA', 'Plan 3 de gobierno del Frente Amplio.', 4, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 1 RN', 'Plan 1 de gobierno del Restauracion Nacional.', 5, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 2 RN', 'Plan 2 de gobierno del Restauracion Nacional.', 5, GETDATE(), DATEADD(year, 5, GETDATE())),
('Plan 3 RN', 'Plan 3 de gobierno del Restauracion Nacional.', 5, GETDATE(), DATEADD(year, 5, GETDATE()));

-- ACCION
DECLARE @c SMALLINT = 1;

WHILE @c < 16
BEGIN

	INSERT INTO Accion (planid, descripcion, kpiType)
	VALUES 
	(@c, 'Traer empresas internacionales.', 'empresas'),
	(@c, 'Eliminar restricciones vehiculares.', 'restricciones'),
	(@c, 'Aumentar impuestos.', 'impuestos');

	SET @c = @c + 1;
		
END;

-- PROVINCIA
INSERT INTO Provincia (nombre)
VALUES 
('San Jose'),
('Cartago'),
('Alajuela'),
('Heredia'),
('Limon'),
('Puntarenas'),
('Guanacaste');

-- CANTON
INSERT INTO Canton (nombre, provinciaId)
VALUES 
('Tibas', 1),
('Alajuelita', 1),
('Desamparados', 1),
('Paraiso', 2),
('Turrialba', 2),
('La Union', 2),
('Atenas', 3),
('Grecia', 3),
('Naranjo', 3),
('Barva', 4),
('Flores', 4),
('San Rafael', 4),
('Guacimo', 5),
('Talamanca', 5),
('Pococi', 5),
('Garabito', 6),
('Coto Brus', 6),
('Golfito', 6),
('Liberia', 7),
('Carrillo', 7),
('Nicoya', 7);

-- ENTREGABLE
DECLARE @cantidad INT;
DECLARE @canton INT;
DECLARE @accion INT;
DECLARE @kpiType NVARCHAR(20);
DECLARE @plan INT;
DECLARE @postTime DATE;

Declare @DateStart	Date = '2001-01-01'
		,@DateEnd	Date = '2022-01-01'

SET @accion = 45

WHILE @accion > 0
BEGIN

	SET @cantidad = RAND()*(8-3)+3; -- Numero random entre 3 y 7

	WHILE @cantidad > 0
	BEGIN

		SET @kpiType = (SELECT kpiType FROM Accion WHERE accionId = @accion);
		SET @plan = (SELECT planId FROM Accion WHERE accionId = @accion);
		SET @canton = RAND()*(11-1)+1; -- Numero random entre 1 y 10
		SET @postTime = DateAdd(Day, Rand() * DateDiff(Day, @DateStart, @DateEnd), @DateStart)
		
		INSERT INTO Entregable (planid, cantonId, kpiValue, kpiType, postTime, checksum, accionId, fechaFinalizacion, satisfaccion)
		VALUES (@plan, @canton, RAND()*(50-1)+1, @kpiType, @postTime, CHECKSUM(@canton,@accion),@accion, DATEADD(year, RAND()*(11-1)+1, @postTime), (RAND()*(100-1)+1)/100);

		SET @cantidad = @cantidad - 1;

	END;
 
	SET @accion = @accion - 1;
	
END;

-- TIPOUSUARIO
INSERT INTO TipoUsuario (nombre)
VALUES
('Manager'),
('Ciudadano'),
('Presidente'),
('Vicepresidente'),
('Tesorero'),
('Propaganda');

-- USUARIO
INSERT INTO Usuario (nombre, apellidos, password, tipoUsuarioId, fechaCreacion, partidoId, cedula)
VALUES
('Karen', 'Colmenares', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Guy', 'Himuro', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Irene', 'Mikkilineni', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Sigal', 'Tobias', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Shelli', 'Baida', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Alexander', 'Khoo', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Britney', 'Everett', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Sarah', 'Bell', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Diana', 'Lorentz', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Jennifer', 'Whalen', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('David', 'Austin', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012'),
('Valli', 'Pataballa', 'asdf', RAND()*(7-1)+1, GETDATE(), RAND()*(6-1)+1, '123456789012');

-- CANTONPERUSUARIO

-- CALIFICACIONENTREGABLES