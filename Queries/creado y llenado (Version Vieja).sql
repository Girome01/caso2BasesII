USE [master]
GO

DROP DATABASE IF EXISTS [bases2_caso1];

/****** Object:  Database [bases2_caso1]    Script Date: 2/26/2022 6:11:41 PM ******/
CREATE DATABASE [bases2_caso1]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bases2_caso1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\DATA\bases2_caso1.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'bases2_caso1_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\DATA\bases2_caso1_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [bases2_caso1] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bases2_caso1].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bases2_caso1] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bases2_caso1] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bases2_caso1] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bases2_caso1] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bases2_caso1] SET ARITHABORT OFF 
GO
ALTER DATABASE [bases2_caso1] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bases2_caso1] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bases2_caso1] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bases2_caso1] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bases2_caso1] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bases2_caso1] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bases2_caso1] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bases2_caso1] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bases2_caso1] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bases2_caso1] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bases2_caso1] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bases2_caso1] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bases2_caso1] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bases2_caso1] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bases2_caso1] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bases2_caso1] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bases2_caso1] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bases2_caso1] SET RECOVERY FULL 
GO
ALTER DATABASE [bases2_caso1] SET  MULTI_USER 
GO
ALTER DATABASE [bases2_caso1] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bases2_caso1] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bases2_caso1] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bases2_caso1] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [bases2_caso1] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [bases2_caso1] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'bases2_caso1', N'ON'
GO
ALTER DATABASE [bases2_caso1] SET QUERY_STORE = OFF
GO
USE [bases2_caso1]
GO

/****** Object:  Table [dbo].[Partido]    Script Date: 2/26/2022 6:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partido](
	[partidoId] [smallint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[bandera] [varbinary](max) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Partido] PRIMARY KEY CLUSTERED 
(
	[partidoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
USE [bases2_caso1]
GO

ALTER TABLE [dbo].[Plan] DROP CONSTRAINT [FK_Plan_Partido]
GO

ALTER TABLE [dbo].[Plan] DROP CONSTRAINT [DF_Plan_fechaFinaliza]
GO

ALTER TABLE [dbo].[Plan] DROP CONSTRAINT [DF_Plan_fechaInicio]
GO

/****** Object:  Table [dbo].[Plan]    Script Date: 4/3/2022 20:21:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Plan]') AND type in (N'U'))
DROP TABLE [dbo].[Plan]
GO

/****** Object:  Table [dbo].[Plan]    Script Date: 4/3/2022 20:21:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Plan](
	[planId] [int] IDENTITY(1,1) NOT NULL,
	[titulo] [nvarchar](100) NOT NULL,
	[descripcion] [nvarchar](300) NOT NULL,
	[partidoId] [smallint] NOT NULL,
	[fechaInicio] [datetime] NOT NULL,
	[fechaFinaliza] [datetime] NOT NULL,
 CONSTRAINT [PK_Plan] PRIMARY KEY CLUSTERED 
(
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Plan] ADD  CONSTRAINT [DF_Plan_fechaInicio]  DEFAULT (getdate()) FOR [fechaInicio]
GO

ALTER TABLE [dbo].[Plan] ADD  CONSTRAINT [DF_Plan_fechaFinaliza]  DEFAULT (getdate()) FOR [fechaFinaliza]
GO

ALTER TABLE [dbo].[Plan]  WITH CHECK ADD  CONSTRAINT [FK_Plan_Partido] FOREIGN KEY([partidoId])
REFERENCES [dbo].[Partido] ([partidoId])
GO

ALTER TABLE [dbo].[Plan] CHECK CONSTRAINT [FK_Plan_Partido]
GO

/****** Object:  Table [dbo].[Accion]    Script Date: 2/26/2022 6:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accion](
	[accionId] [int] IDENTITY(1,1) NOT NULL,
	[planId] [int] NOT NULL,
	[descripcion] [nvarchar](500) NOT NULL,
	[kpiType] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Accion] PRIMARY KEY CLUSTERED 
(
	[accionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[Provincia]    Script Date: 2/26/2022 6:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provincia](
	[provinciaId] [smallint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Provincia] PRIMARY KEY CLUSTERED 
(
	[provinciaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Canton]    Script Date: 2/26/2022 6:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Canton](
	[cantonId] [smallint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[provinciaId] [smallint] NOT NULL,
 CONSTRAINT [PK_Canton] PRIMARY KEY CLUSTERED 
(
	[cantonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[Entregable]    Script Date: 4/3/2022 20:13:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Entregable]') AND type in (N'U'))
DROP TABLE [dbo].[Entregable]
GO

/****** Object:  Table [dbo].[Entregable]    Script Date: 4/3/2022 20:13:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Entregable](
	[entregableId] [smallint] IDENTITY(1,1) NOT NULL,
	[planId] [int] NOT NULL,
	[cantonId] [smallint] NOT NULL,
	[kpiValue] [smallint] NOT NULL,
	[kpiType] [nvarchar](50) NOT NULL,
	[postTime] [date] NOT NULL,
	[checksum] [bigint] NOT NULL,
	[accionId] [int] NOT NULL,
	[fechaFinalizacion] [datetime] NOT NULL,
	[satisfaccion] [float] NOT NULL,
 CONSTRAINT [PK_entregable] PRIMARY KEY CLUSTERED 
(
	[entregableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Entregable]  WITH CHECK ADD  CONSTRAINT [FK_Entregable_Accion] FOREIGN KEY([accionId])
REFERENCES [dbo].[Accion] ([accionId])
GO

ALTER TABLE [dbo].[Entregable] CHECK CONSTRAINT [FK_Entregable_Accion]
GO

ALTER TABLE [dbo].[Entregable]  WITH CHECK ADD  CONSTRAINT [FK_Entregable_Canton] FOREIGN KEY([cantonId])
REFERENCES [dbo].[Canton] ([cantonId])
GO

ALTER TABLE [dbo].[Entregable] CHECK CONSTRAINT [FK_Entregable_Canton]
GO

ALTER TABLE [dbo].[Entregable]  WITH CHECK ADD  CONSTRAINT [FK_Entregable_Plan] FOREIGN KEY([planId])
REFERENCES [dbo].[Plan] ([planId])
GO

ALTER TABLE [dbo].[Entregable] CHECK CONSTRAINT [FK_Entregable_Plan]
GO


/****** Object:  Table [dbo].[TipoUsuario]    Script Date: 2/26/2022 6:11:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoUsuario](
	[tipoUsuarioId] [smallint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](30) NOT NULL,
	[descripcion] [nvarchar](100) NULL,
 CONSTRAINT [PK_tipoUsuario] PRIMARY KEY CLUSTERED 
(
	[tipoUsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [bases2_caso1]
GO

ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [FK_usuario_tipoUsuario_tipoUsuarioId]
GO

ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [FK_Usuario_Partido]
GO

/****** Object:  Table [dbo].[Usuario]    Script Date: 4/3/2022 20:23:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario]') AND type in (N'U'))
DROP TABLE [dbo].[Usuario]
GO

/****** Object:  Table [dbo].[Usuario]    Script Date: 4/3/2022 20:23:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Usuario](
	[usuarioId] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[apellidos] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[foto] [varbinary](max) NULL,
	[tipoUsuarioId] [smallint] NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[partidoId] [smallint] NOT NULL,
	[cedula] [char](12) NOT NULL,
 CONSTRAINT [PK_usuario] PRIMARY KEY CLUSTERED 
(
	[usuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Partido] FOREIGN KEY([partidoId])
REFERENCES [dbo].[Partido] ([partidoId])
GO

ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Partido]
GO

ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_usuario_tipoUsuario_tipoUsuarioId] FOREIGN KEY([tipoUsuarioId])
REFERENCES [dbo].[TipoUsuario] ([tipoUsuarioId])
GO

ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_usuario_tipoUsuario_tipoUsuarioId]
GO

USE [bases2_caso1]
GO

ALTER TABLE [dbo].[Vive] DROP CONSTRAINT [FK_Vive_Canton_cantonId]
GO

/****** Object:  Table [dbo].[Vive]    Script Date: 4/3/2022 20:24:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vive]') AND type in (N'U'))
DROP TABLE [dbo].[Vive]
GO

/****** Object:  Table [dbo].[Vive]    Script Date: 4/3/2022 20:24:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Vive](
	[cantonid] [smallint] NOT NULL,
	[viveId] [bigint] IDENTITY(1,1) NOT NULL,
	[posttime] [datetime] NOT NULL,
	[enuso] [bit] NOT NULL,
	[actual] [bit] NOT NULL,
 CONSTRAINT [PK_Vive] PRIMARY KEY CLUSTERED 
(
	[viveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Vive]  WITH CHECK ADD  CONSTRAINT [FK_Vive_Canton_cantonId] FOREIGN KEY([cantonid])
REFERENCES [dbo].[Canton] ([cantonId])
GO

ALTER TABLE [dbo].[Vive] CHECK CONSTRAINT [FK_Vive_Canton_cantonId]
GO

USE [bases2_caso1]
GO

ALTER TABLE [dbo].[calificacionEntregables] DROP CONSTRAINT [FK_calificacionEntregables_Usuario_usuarioId]
GO

ALTER TABLE [dbo].[calificacionEntregables] DROP CONSTRAINT [FK_calificacionEntregables_Entregable_entregableId]
GO

/****** Object:  Table [dbo].[calificacionEntregables]    Script Date: 4/3/2022 20:24:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calificacionEntregables]') AND type in (N'U'))
DROP TABLE [dbo].[calificacionEntregables]
GO

/****** Object:  Table [dbo].[calificacionEntregables]    Script Date: 4/3/2022 20:24:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[calificacionEntregables](
	[calificacionEntregableId] [bigint] IDENTITY(1,1) NOT NULL,
	[entregableID] [smallint] NOT NULL,
	[usuarioId] [bigint] NOT NULL,
	[rank] [tinyint] NOT NULL,
	[posttime] [datetime] NOT NULL,
	[checksum] [varbinary](150) NOT NULL,
 CONSTRAINT [PK_calificacionEntregables] PRIMARY KEY CLUSTERED 
(
	[calificacionEntregableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[calificacionEntregables]  WITH CHECK ADD  CONSTRAINT [FK_calificacionEntregables_Entregable_entregableId] FOREIGN KEY([entregableID])
REFERENCES [dbo].[Entregable] ([entregableId])
GO

ALTER TABLE [dbo].[calificacionEntregables] CHECK CONSTRAINT [FK_calificacionEntregables_Entregable_entregableId]
GO

ALTER TABLE [dbo].[calificacionEntregables]  WITH CHECK ADD  CONSTRAINT [FK_calificacionEntregables_Usuario_usuarioId] FOREIGN KEY([usuarioId])
REFERENCES [dbo].[Usuario] ([usuarioId])
GO

ALTER TABLE [dbo].[calificacionEntregables] CHECK CONSTRAINT [FK_calificacionEntregables_Usuario_usuarioId]
GO



-- LLENADO

use bases2_caso1;

INSERT INTO Partido (nombre, bandera, fechaCreacion)
VALUES 
('PLN', 100000, GETDATE()),
('PAC', 100001, GETDATE()),
('PUSC', 100002, GETDATE()),
('FA', 100003, GETDATE());

INSERT INTO [Plan] (titulo, descripcion, partidoId)
VALUES 
('Plan PLN', 'Plan de gobierno del Partido Liberacion Nacional.', 1),
('Plan PAC', 'Plan de gobierno del Partido Accion Ciudadana.', 2),
('Plan PUSC', 'Plan de gobierno del Partido Unidad Social Cristiana.', 3),
('Plan FA', 'Plan de gobierno del Frente Amplio.', 4);

INSERT INTO Accion (planid, descripcion, kpiType)
VALUES 
(1, 'Traer empresas internacionales.', 'empresas'),
(1, 'Eliminar restricciones vehiculares.', 'restricciones'),
(1, 'Aumentar impuestos.', 'impuestos'),
(2, 'Traer empresas internacionales.', 'empresas'),
(2, 'Eliminar restricciones vehiculares.', 'restricciones'),
(2, 'Aumentar impuestos.', 'impuestos'),
(3, 'Traer empresas internacionales.', 'empresas'),
(3, 'Eliminar restricciones vehiculares.', 'restricciones'),
(3, 'Aumentar impuestos.', 'impuestos'),
(4, 'Traer empresas internacionales.', 'empresas'),
(4, 'Eliminar restricciones vehiculares.', 'restricciones'),
(4, 'Aumentar impuestos.', 'impuestos');

INSERT INTO Provincia (nombre)
VALUES 
('San Jose'),
('Cartago'),
('Alajuela'),
('Heredia'),
('Limon'),
('Puntarenas'),
('Guanacaste');

INSERT INTO Canton (nombre, provinciaId)
VALUES 
('Tibas', 1),
('Paraiso', 2),
('Atenas', 3),
('Barva', 4),
('Guacimo', 5),
('Garabito', 6),
('Liberia', 7),
('Alajuelita', 1),
('Turrialba', 2),
('Grecia', 3);

DECLARE @cantidad INT;
DECLARE @canton INT;
DECLARE @accion INT;
DECLARE @kpiType NVARCHAR(20);
DECLARE @plan INT;
DECLARE @fechaFinalizacion datetime;
DECLARE @years INT;

SET @accion = 12

WHILE @accion > 0
BEGIN

	SET @cantidad = RAND()*(8-3)+3; -- Numero random entre 3 y 7

	WHILE @cantidad > 0
	BEGIN

		SET @kpiType = (SELECT kpiType FROM Accion WHERE accionId = @accion);
		SET @plan = (SELECT planId FROM Accion WHERE accionId = @accion);
		SET @canton = RAND()*(11-1)+1; -- Numero random entre 1 y 10

		SET @years = (1 + floor(rand()* 4))* -1
		SET @fechaFinalizacion = dateadd(year, @years, getdate())
		SET @fechaFinalizacion = dateadd(day, CASE WHEN rand() < 0.5 THEN -1 ELSE 1 END * 20 * rand(), @fechaFinalizacion)
		
		INSERT INTO Entregable (planid, cantonId, kpiValue, kpiType, postTime, checksum, accionId, fechaFinalizacion)
		VALUES (@plan, @canton, RAND()*(50-1)+1, @kpiType, GETDATE(), CHECKSUM(@canton,@accion),@accion, @fechaFinalizacion);

		SET @cantidad = @cantidad - 1;
	END;
 
	SET @accion = @accion - 1;
END;


DECLARE @idTipo SMALLINT
SET @idTipo = ISNULL( (SELECT tipo.tipoUsuarioId FROM dbo.TipoUsuario tipo
WHERE TRIM('Ciudadano')= tipo.nombre), -1)

IF(@idTipo = -1)
	INSERT INTO dbo.TipoUsuario(nombre) VALUES
	('Ciudadano')


SET @idTipo = ISNULL( (SELECT tipo.tipoUsuarioId FROM dbo.TipoUsuario tipo
WHERE TRIM('Encargados de campaña')= tipo.nombre), -1)
IF(@idTipo = -1)
	insert into dbo.TipoUsuario(nombre) values
	('Encargados de campaña')

DECLARE @cantUsuarios INT
DECLARE @nombre VARCHAR(25)
DECLARE @apellido VARCHAR(25)
DECLARE @clave VARCHAR(25)
DECLARE @urlfoto VARCHAR(150)
DECLARE @diaCreacion DATETIME
DECLARE @partidoId SMALLINT
DECLARE @years INT

SET @cantUsuarios = 2

WHILE @cantUsuarios>0 BEGIN
    SET @years = (4 + floor(rand()* 10))* -1
    SET @diaCreacion = dateadd(year, @years, getdate())

    SET @diaCreacion = dateadd(day, CASE WHEN rand() < 0.5 THEN -1 ELSE 1 END * 200 * rand(), @diaCreacion)
	SET @partidoId = ( FLOOR(RAND()*(4 - 1+1))+1) 

    INSERT INTO Usuario 
    (nombre, apellidos, password, foto, tipoUsuarioId, fechaCreacion, partidoId, cedula)
    VALUES
    ('Nombre'+CONVERT(VARCHAR,floor(999999*rand())), 
    'Apellido '+CONVERT(VARCHAR, floor(999999*rand())), 
    'password '+CONVERT(VARCHAR,floor(999999*rand())),
	CONVERT(varbinary,'URLFOTO'+CONVERT(VARCHAR,floor(999999*rand()))), 
	1, @diaCreacion, @partidoId, 'CEDULA'+CONVERT(VARCHAR,floor(999999*rand())))


    SET @cantUsuarios = @cantUsuarios - 1
END

INSERT INTO calificacionEntregables (entregableID, usuarioId, "rank", posttime, "checksum")
VALUES
(1, 1, 22, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(2, 1, 55, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )), 
(3, 1, 88, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(4, 1, 99, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(5, 1, 10, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(6, 1, 20, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(1, 1, 50, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(1, 1, 60, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) )),
(4, 1, 12, getdate(), HASHBYTES('SHA2_256', ('kpiValue'+CONVERT(VARCHAR, floor(999999*rand()))) ))