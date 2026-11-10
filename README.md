# PA3 - Programación Avanzada de Base de Datos
## Proyecto: Sistema de Gestión de Ventas - EmpresaVentas

**Institución:** ISIL  
**Curso:** Programación Avanzada de Base de Datos  
**Código:** 30627  
**Evaluación:** PA3 - Proceso de Aprendizaje 3  
**Periodo:** 202620  
**Gestor de base de datos:** Microsoft SQL Server

---

## 👥 Integrantes

1. Percy Astocahuana Buendía
2. Nelson Amado Del Portal Neyra
3. Luis Ángel Chávez Quispe
4. Diego Fernando Martinez del Carpio
5. Gerson Alberto Pinto Leguia

---

## 📝 Descripción del proyecto

El presente proyecto consiste en desarrollar una base de datos para gestionar las operaciones de una empresa dedicada a la venta de productos, utilizando Microsoft SQL Server.

La base de datos denominada `EmpresaVentas` permite administrar información de clientes, productos, ventas y detalles de venta mediante una estructura relacional.

Para esta evaluación PA3 se implementarán procedimientos almacenados y transacciones que permitan automatizar operaciones de mantenimiento, registrar ventas, controlar el stock de productos y garantizar la integridad de la información.

El proyecto busca aplicar los conocimientos desarrollados durante el curso de Programación Avanzada de Base de Datos, enfocándose en la programación de objetos del lado del servidor.

---

## 🎯 Objetivo

Implementar procedimientos almacenados y transacciones en SQL Server para automatizar las operaciones de la empresa, facilitar el mantenimiento de los datos y garantizar la consistencia de las operaciones de venta.

Se aplicarán los siguientes conceptos:

- Creación y modificación de procedimientos almacenados.
- Parámetros de entrada y salida.
- Valores de retorno.
- Procedimientos de mantenimiento de tablas.
- Arquitectura cliente/servidor en dos capas.
- Transacciones implícitas.
- Transacciones de autoconfirmación.
- Transacciones explícitas.
- BEGIN TRANSACTION.
- COMMIT TRANSACTION.
- ROLLBACK TRANSACTION.
- Integración de transacciones en procedimientos almacenados.
- Pruebas y validación de operaciones.

---

## 🗄️ Estructura de la base de datos

La base de datos `EmpresaVentas` está conformada por cuatro tablas principales:

### 1. Tabla Clientes

Almacena la información de los clientes registrados en la empresa.

| Campo | Tipo de dato | Descripción |
|---|---|---|
| IdCliente | INT IDENTITY | Identificador del cliente (PK). |
| Nombre | VARCHAR(100) | Nombre del cliente. |
| Apellido | VARCHAR(100) | Apellido del cliente. |
| Telefono | VARCHAR(20) | Número telefónico. |
| Correo | VARCHAR(100) | Correo electrónico. |

### 2. Tabla Productos

Almacena los productos disponibles para la venta.

| Campo | Tipo de dato | Descripción |
|---|---|---|
| IdProducto | INT IDENTITY | Identificador del producto (PK). |
| NombreProducto | VARCHAR(100) | Nombre del producto. |
| Precio | DECIMAL(10,2) | Precio del producto. |
| Stock | INT | Cantidad disponible. |

### 3. Tabla Ventas

Registra las ventas realizadas por los clientes.

| Campo | Tipo de dato | Descripción |
|---|---|---|
| IdVenta | INT IDENTITY | Identificador de la venta (PK). |
| IdCliente | INT | Identificador del cliente (FK). |
| FechaVenta | DATETIME | Fecha de registro de la venta. |

### 4. Tabla DetalleVenta

Almacena los productos incluidos en cada venta.

| Campo | Tipo de dato | Descripción |
|---|---|---|
| IdDetalle | INT IDENTITY | Identificador del detalle (PK). |
| IdVenta | INT | Identificador de la venta (FK). |
| IdProducto | INT | Identificador del producto (FK). |
| Cantidad | INT | Cantidad de productos vendidos. |
| Precio | DECIMAL(10,2) | Precio aplicado al producto. |

### Relaciones entre las tablas

- Un cliente puede realizar varias ventas.
- Una venta pertenece a un cliente.
- Una venta puede contener varios detalles de venta.
- Un producto puede aparecer en diferentes detalles de venta.
- Cada detalle de venta pertenece a una venta y referencia un producto.

---

## ⚙️ Desarrollo del proyecto

El proyecto se desarrolla tomando como base la estructura relacional de `EmpresaVentas`.

Se trabajarán las siguientes actividades:

### Actividad 1: Identificación del proceso a automatizar

Se selecciona el proceso de registro de ventas como una operación que puede automatizarse mediante procedimientos almacenados.

El proceso contempla:

- Recibir el identificador del cliente.
- Recibir los productos que se desean vender.
- Validar la existencia del cliente.
- Verificar que los productos estén registrados.
- Comprobar que exista stock suficiente.
- Registrar la venta y sus respectivos detalles.
- Actualizar el stock de los productos.

**Justificación:**

La automatización de este proceso permite centralizar las reglas de negocio en el servidor, reducir la repetición de instrucciones SQL y controlar las operaciones realizadas sobre las tablas relacionadas.

### Actividad 2: Procedimientos almacenados de mantenimiento

Se implementarán procedimientos almacenados para automatizar operaciones sobre las tablas de la base de datos.

Entre las operaciones consideradas se encuentran:

- Registrar clientes.
- Registrar productos.
- Actualizar información de productos.
- Consultar información mediante parámetros.
- Registrar operaciones de venta.

Se utilizarán parámetros de entrada, parámetros de salida y valores de retorno cuando corresponda.

### Actividad 3: Diseño de una operación transaccional

Se implementará una transacción explícita para registrar una venta y sus respectivos detalles.

La operación contempla:

1. Verificar que el cliente exista.
2. Verificar que los productos estén registrados.
3. Comprobar que exista stock suficiente.
4. Registrar la venta.
5. Registrar los detalles de venta.
6. Descontar las cantidades correspondientes del stock.
7. Confirmar la operación mediante COMMIT TRANSACTION.

Criterios de Confirmación (COMMIT) y Cancelación (ROLLBACK):
En caso de producirse un error o incumplirse alguna validación en los pasos 1, 2 o 3, se cancelarán los cambios de inmediato mediante ROLLBACK TRANSACTION. De esta manera se evita que una venta quede registrada parcialmente o que se altere el stock de forma indebida. Solo si las validaciones se superan y las sentencias de modificación se ejecutan sin errores de sistema, se emite el COMMIT TRANSACTION, aplicando todos los cambios de forma definitiva y simultánea.

Justificación del Comportamiento Transaccional:
Para este desarrollo se eligió una Transacción Explícita. A diferencia de la Transacción de Autoconfirmación, donde cada instrucción como un INSERT se confirma sola de forma aislada, y la Transacción Implícita, donde el sistema la inicia pero requiere cierre manual, la transacción explícita permite definir intencionalmente dónde empieza y dónde termina el bloque de operaciones. Es la única forma segura de agrupar múltiples operaciones que dependen entre sí como registrar una venta y descontar stock, esto asegura que se comporten como una única unidad lógica inquebrantable.

### Actividad 4: Pruebas comparativas y validación

Se realizarán pruebas para comprobar el funcionamiento de la transacción en dos escenarios.

**Escenario 1: Transacción exitosa**

- Seleccionar un cliente existente.
- Seleccionar productos con stock suficiente.
- Registrar la venta.
- Registrar sus detalles.
- Actualizar el stock.
- Confirmar los cambios mediante COMMIT.

**Resultado esperado:** la venta y sus detalles quedan registrados y el stock se reduce correctamente.

**Escenario 2: Transacción cancelada**

- Seleccionar un cliente existente.
- Intentar registrar una venta con un producto que no tenga stock suficiente.
- Ejecutar las validaciones correspondientes.
- Cancelar la operación mediante ROLLBACK.

**Resultado esperado:** no se mantienen cambios parciales en las tablas Ventas, DetalleVenta ni Productos.

---

## 💡 Solución propuesta

La solución consiste en implementar procedimientos almacenados y transacciones en Microsoft SQL Server para gestionar de manera controlada las operaciones de la empresa.

Se busca centralizar la lógica de mantenimiento y registro de ventas en el servidor, permitiendo que las operaciones se ejecuten bajo reglas previamente establecidas.

Los principales elementos de la solución serán:

- Procedimientos almacenados para registrar y actualizar información.
- Parámetros para recibir y devolver información.
- Validaciones para controlar las operaciones.
- Transacciones explícitas para registrar ventas.
- COMMIT para confirmar operaciones exitosas.
- ROLLBACK para cancelar operaciones no válidas.
- Pruebas para comprobar la consistencia de los datos.

---

## 📂 Estructura del proyecto

```text
PA3-EmpresaVentas/
│
├── README.md
│
├── Base de Datos/
│   └── EmpresaVentas.sql
│
├── Actividad 1/
│   └── Proceso_Automatizar.md
│
├── Actividad 2/
│   └── Procedimientos_Almacenados.sql
│
├── Actividad 3/
│   └── Transacciones.sql
│
├── Actividad 4/
│   └── Pruebas_Transaccionales.sql
│
└── Evidencias/
    ├── Actividad1/
    ├── Actividad2/
    ├── Actividad3/
    └── Actividad4/
```

*Los nombres de los archivos y carpetas deben coincidir con los que finalmente se publiquen en GitHub.*

---

## ▶️ Cómo ejecutar o revisar el proyecto

Para ejecutar el proyecto se requiere:

1. Tener instalado Microsoft SQL Server.
2. Abrir SQL Server Management Studio (SSMS).
3. Ejecutar el script `EmpresaVentas.sql`.
4. Verificar la creación de las cuatro tablas y sus relaciones.
5. Ejecutar los scripts de procedimientos almacenados.
6. Ejecutar los scripts de transacciones.
7. Realizar las pruebas de confirmación y cancelación.
8. Revisar las evidencias y los resultados obtenidos.

---

## 📷 Evidencias del proyecto

Se incorporarán capturas de pantalla que demuestren la implementación y ejecución de las actividades.

### Actividad 1: Identificación del proceso
- Descripción del proceso de registro de ventas.
- Diagrama o pseudocódigo del proceso.

### Actividad 2: Procedimientos almacenados
- Creación de procedimientos almacenados.
- Ejecución con parámetros de entrada.
- Resultados de parámetros de salida y valores de retorno.

### Actividad 3: Transacciones
- Implementación de BEGIN TRANSACTION.
- Ejecución de COMMIT TRANSACTION.
- Ejecución de ROLLBACK TRANSACTION.

### Actividad 4: Pruebas y validaciones
- Evidencia de una venta registrada correctamente.
- Evidencia de una operación cancelada.
- Comparación del stock antes y después.
- Verificación de los registros en las tablas relacionadas.

---

## 📚 Conclusiones

- Se diseñó una base de datos relacional para gestionar clientes, productos y ventas mediante Microsoft SQL Server.
- Se aplicaron procedimientos almacenados para automatizar operaciones de mantenimiento.
- Se comprendió la importancia de los parámetros de entrada y salida en los procedimientos almacenados.
- Se aplicaron transacciones explícitas para controlar las operaciones de registro de ventas.
- Se utilizaron COMMIT y ROLLBACK para confirmar o cancelar operaciones.
- Se realizaron pruebas para comprobar la integridad y consistencia de los datos.
- El proyecto permitió reforzar los conocimientos de programación del lado del servidor y administración de bases de datos.

---

## 🎥 Video de exposición

**Video público de YouTube:https://youtu.be/kigdaBe14JA?si=HZJhq6g53d0U3--l 

---

**Proyecto académico desarrollado para el curso de Programación Avanzada de Base de Datos - ISIL.**
