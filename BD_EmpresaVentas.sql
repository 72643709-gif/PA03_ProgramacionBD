CREATE DATABASE EmpresaVentas;
GO

USE EmpresaVentas;
GO

CREATE TABLE Clientes(
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Correo VARCHAR(100)
);


CREATE TABLE Productos(
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    NombreProducto VARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

CREATE TABLE Ventas(
    IdVenta INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    FechaVenta DATETIME DEFAULT GETDATE(),

    FOREIGN KEY(IdCliente)
    REFERENCES Clientes(IdCliente)
);



CREATE TABLE DetalleVenta(
    IdDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,

    FOREIGN KEY(IdVenta)
    REFERENCES Ventas(IdVenta),

    FOREIGN KEY(IdProducto)
    REFERENCES Productos(IdProducto)
);