

USE DataSalud_Peru;
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'LogAuditoria')
BEGIN
    CREATE TABLE LogAuditoria (
        ID_Log INT IDENTITY(1,1) PRIMARY KEY,
        TablaAfectada VARCHAR(100),
        Operacion VARCHAR(20),
        UsuarioBD VARCHAR(100) DEFAULT SYSTEM_USER,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        DetalleCambio VARCHAR(MAX)
    );
END;
GO


CREATE OR ALTER TRIGGER trg_Auditoria_Atenciones
ON dbo.Atenciones_SIS
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Operacion VARCHAR(20);
    
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';

    INSERT INTO LogAuditoria (TablaAfectada, Operacion, DetalleCambio)
    VALUES ('Atenciones_SIS', @Operacion, 'Modificación registrada en la tabla de atenciones del SIS');
END;
GO


CREATE OR ALTER PROCEDURE sp_IngresarAtencionSIS
    @Region VARCHAR(100),
    @Provincia VARCHAR(100),
    @Distrito VARCHAR(100),
    @UnidadEjecutora VARCHAR(100),
    @CantidadAtenciones INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Atenciones_SIS (REGION, PROVINCIA, DISTRITO, UNIDAD_EJECUTORA, CANTIDAD_ATENCIONES)
    VALUES (UPPER(@Region), UPPER(@Provincia), UPPER(@Distrito), @UnidadEjecutora, @CantidadAtenciones);
END;
GO


IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Rol_Administrador')
    CREATE ROLE Rol_Administrador;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Rol_AnalistaDatos')
    CREATE ROLE Rol_AnalistaDatos;
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Rol_Auditor')
    CREATE ROLE Rol_Auditor;
GO


GRANT CONTROL TO Rol_Administrador;
GRANT SELECT ON dbo.Atenciones_SIS TO Rol_AnalistaDatos;
GRANT SELECT ON dbo.LogAuditoria TO Rol_Auditor;
GO