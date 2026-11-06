
USE EmpresaVentas;
GO

-- ACTIVIDAD 4: PRUEBAS DE TRANSACCIONES

-- Procedimiento para registrar una venta
CREATE OR ALTER PROCEDURE dbo.PA3_RegistrarVenta
    @IdCliente INT,
    @IdProducto INT,
    @Cantidad INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Precio DECIMAL(10,2);
    DECLARE @IdVenta INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Comprobar los datos
        IF @Cantidad IS NULL OR @Cantidad <= 0
            THROW 50001, 'Cantidad incorrecta', 1;

        IF NOT EXISTS (
            SELECT 1 FROM Clientes
            WHERE IdCliente = @IdCliente
        )
            THROW 50002, 'Cliente no encontrado', 1;

        SELECT @Precio = Precio
        FROM Productos
        WHERE IdProducto = @IdProducto;

        IF @Precio IS NULL
            THROW 50003, 'Producto no encontrado', 1;

        -- Registrar la venta
        INSERT INTO Ventas (IdCliente)
        VALUES (@IdCliente);

        SET @IdVenta = SCOPE_IDENTITY();

        INSERT INTO DetalleVenta
            (IdVenta, IdProducto, Cantidad, Precio)
        VALUES
            (@IdVenta, @IdProducto, @Cantidad, @Precio);

        -- Descontar stock solamente si alcanza
        UPDATE Productos
        SET Stock = Stock - @Cantidad
        WHERE IdProducto = @IdProducto
          AND Stock >= @Cantidad;

        IF @@ROWCOUNT = 0
            THROW 50004, 'Stock insuficiente', 1;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- ======================================
-- PREPARAR DATOS DE PRUEBA
-- ======================================

DECLARE @Cliente INT;
DECLARE @Producto INT;
DECLARE @Error NVARCHAR(200) = 'Ninguno';

DECLARE @Resultados TABLE (
    Orden INT,
    Etapa VARCHAR(40),
    Stock INT,
    Ventas INT,
    Detalles INT
);

INSERT INTO Clientes (Nombre, Apellido)
VALUES ('Cliente PA3', 'Prueba');

SET @Cliente = SCOPE_IDENTITY();

INSERT INTO Productos (NombreProducto, Precio, Stock)
VALUES ('Producto PA3', 25.00, 10);

SET @Producto = SCOPE_IDENTITY();

-- ======================================
-- 1. ANTES DE LAS PRUEBAS
-- ======================================

INSERT INTO @Resultados
SELECT 1, 'ANTES', Stock, 0, 0
FROM Productos
WHERE IdProducto = @Producto;

-- ======================================
-- 2. PRUEBA EXITOSA: COMMIT
-- ======================================

EXEC dbo.PA3_RegistrarVenta
    @IdCliente = @Cliente,
    @IdProducto = @Producto,
    @Cantidad = 2;

INSERT INTO @Resultados
SELECT 2, 'DESPUES DEL COMMIT',
       Stock,
       (SELECT COUNT(*) FROM Ventas
        WHERE IdCliente = @Cliente),
       (SELECT COUNT(*) FROM DetalleVenta
        WHERE IdProducto = @Producto)
FROM Productos
WHERE IdProducto = @Producto;

-- ======================================
-- 3. PRUEBA FALLIDA: ROLLBACK
-- ======================================

BEGIN TRY
    EXEC dbo.PA3_RegistrarVenta
        @IdCliente = @Cliente,
        @IdProducto = @Producto,
        @Cantidad = 20;
END TRY
BEGIN CATCH
    SET @Error = ERROR_MESSAGE();
END CATCH;

INSERT INTO @Resultados
SELECT 3, 'DESPUES DEL ROLLBACK',
       Stock,
       (SELECT COUNT(*) FROM Ventas
        WHERE IdCliente = @Cliente),
       (SELECT COUNT(*) FROM DetalleVenta
        WHERE IdProducto = @Producto)
FROM Productos
WHERE IdProducto = @Producto;

-- ======================================
-- 4. MOSTRAR COMPARACION
-- ======================================

SELECT Etapa, Stock, Ventas, Detalles
FROM @Resultados
ORDER BY Orden;

-- Mostrar motivo de cancelacion
SELECT @Error AS MotivoDeCancelacion;

-- Comprobar resultados
SELECT
    CASE
        WHEN (SELECT Stock FROM Productos
              WHERE IdProducto = @Producto) = 8
         AND (SELECT COUNT(*) FROM Ventas
              WHERE IdCliente = @Cliente) = 1
         AND (SELECT COUNT(*) FROM DetalleVenta
              WHERE IdProducto = @Producto) = 1
         AND @Error LIKE '%Stock insuficiente%'
        THEN 'APROBADO: Transacciones correctas'
        ELSE 'REVISAR: Error en las pruebas'
    END AS ResultadoFinal;
