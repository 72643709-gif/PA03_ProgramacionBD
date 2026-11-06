USE EmpresaVentas;
GO

-- Datos a utlizar

INSERT INTO Clientes
    (Nombre, Apellido, Telefono, Correo)
VALUES
    ('Carlos', 'Ramirez', '987654321', 'carlos@gmail.com');

INSERT INTO Productos
    (NombreProducto, Precio, Stock)
VALUES
    ('Laptop Lenovo', 2500.00, 15),
    ('Mouse Logitech', 80.00, 30);
GO


-- Actividad 2: Procedimiento almacenado
/*El Proceso a automatizar es el registro de ventas, que avarcan las Tablas de Ventas y Detalle de ventas

Como se menciona en el flujo, se validara el Cliente, el Proucto, el Stock, luego se Registra la Venta */


create procedure dbo.usp_RegistrarVenta
    @IdCliente int,
    @IdProducto int,
    @Cantidad int
as
begin

    set nocount on;

    -- Validar cantidad  ---
    if (@Cantidad <= 0)
    begin
        print 'Cantidad invalida';
        return 10;
    end

    -- Validar cliente --- si no existe un cliente con ese ID muestra el mensaje y termina
    if not exists (
        select 1
        from Clientes
        where IdCliente = @IdCliente
    )
    begin
        print 'Cliente no encontrado';
        return 20;
    end

    --- Validar producto --- 
    if not exists (
        select 1
        from Productos
        where IdProducto = @IdProducto
    )
    begin
        print 'Producto no encontrado';
        return 30;
    end

    --- Validar stock--- si no existe stock suficiente para el producto muestra el mensaje
    if not exists (
        select 1
        from Productos
        where IdProducto = @IdProducto
        and Stock >= @Cantidad
    )
    begin
        print 'Stock insuficiente';
        return 40;
    end


    -- Registrar venta --
    insert into Ventas (IdCliente)
    values (@IdCliente);

    declare @IdVenta int = scope_identity(); --obtener la ultimo IDENTITY generada que es IdVenta
 

    -- Registrar detalle de venta ---
    insert into DetalleVenta (IdVenta, IdProducto, Cantidad, Precio)
    select @IdVenta,IdProducto,@Cantidad,Precio
    from Productos
    where IdProducto = @IdProducto;

    --- Actualizar stock ----
    update Productos
    set Stock = Stock - @Cantidad
    where IdProducto = @IdProducto;

    print 'Venta registrada correctamente';

    -- Mostrar venta registrada-
    select
        v.IdVenta,
        v.IdCliente,
        p.NombreProducto,
        dv.Cantidad,
        dv.Precio,
        (dv.Cantidad * dv.Precio) as Total
    from Ventas v
    inner join DetalleVenta dv
        on v.IdVenta = dv.IdVenta
    inner join Productos P
        on dv.IdProducto = p.IdProducto
    where v.IdVenta = @IdVenta;

    return 0;

end;
go



declare @Estado int;

exec @Estado = dbo.usp_RegistrarVenta
    @IdCliente = 1,
    @IdProducto = 1,
    @Cantidad = 4;

select @Estado as CodigoResultado;


