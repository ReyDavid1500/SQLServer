CREATE DATABASE rentacardb;
CREATE TABLE Vendedor (
    VendedorId INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(255) NOT NULL
);
CREATE TABLE MarcaAuto (
    MarcaAutoId INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(255) NOT NULL
);
CREATE TABLE ModeloAuto (
    ModeloAutoId INT PRIMARY KEY IDENTITY(1, 1),
    Nombre VARCHAR(255) NOT NULL,
    Precio BIGINT NOT NULL,
    MarcaAutoId INT NOT NULL,
    FOREIGN KEY (MarcaAutoId) REFERENCES MarcaAuto(MarcaAutoId)
);
CREATE TABLE Solicitudes (
    SolicitudId INT PRIMARY KEY IDENTITY(1, 1),
    Cantidad INT NOT NULL,
    Fecha DATE NOT NULL,
    ModeloAutoId INT NOT NULL,
    VendedorId INT NOT NULL,
    FOREIGN KEY (ModeloAutoId) REFERENCES ModeloAuto(ModeloAutoId),
    FOREIGN KEY (VendedorId) REFERENCES Vendedor(VendedorId)
);
--10 vendedores
INSERT INTO Vendedor (Nombre)
VALUES ('Juan Pérez');
INSERT INTO Vendedor (Nombre)
VALUES ('María García');
INSERT INTO Vendedor (Nombre)
VALUES ('Carlos López');
INSERT INTO Vendedor (Nombre)
VALUES ('Ana Martínez');
INSERT INTO Vendedor (Nombre)
VALUES ('Luis Rodríguez');
INSERT INTO Vendedor (Nombre)
VALUES ('Sofía Fernández');
INSERT INTO Vendedor (Nombre)
VALUES ('Miguel Sánchez');
INSERT INTO Vendedor (Nombre)
VALUES ('Lucía González');
INSERT INTO Vendedor (Nombre)
VALUES ('Javier Gómez');
INSERT INTO Vendedor (Nombre)
VALUES ('Elena Díaz');
--5 marcas de autos 
INSERT INTO MarcaAuto (Nombre)
VALUES ('Toyota');
INSERT INTO MarcaAuto (Nombre)
VALUES ('Ford');
INSERT INTO MarcaAuto (Nombre)
VALUES ('Chevrolet');
INSERT INTO MarcaAuto (Nombre)
VALUES ('Honda');
INSERT INTO MarcaAuto (Nombre)
VALUES ('BMW');
--25 modelos de autos
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Corolla', 20000, 1);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Camry', 25000, 1);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('RAV4', 30000, 1);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Mustang', 35000, 2);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('F-150', 40000, 2);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Explorer', 45000, 2);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Silverado', 50000, 3);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Malibu', 55000, 3);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Equinox', 60000, 3);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Civic', 65000, 4);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Accord', 70000, 4);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('CR-V', 75000, 4);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('3 Series', 80000, 5);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('5 Series', 85000, 5);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('X5', 90000, 5);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Highlander', 95000, 1);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Tacoma', 100000, 1);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Escape', 105000, 2);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Fusion', 110000, 2);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Tahoe', 115000, 3);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Trailblazer', 120000, 3);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Pilot', 125000, 4);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('Odyssey', 130000, 4);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('X3', 135000, 5);
INSERT INTO ModeloAuto (Nombre, Precio, MarcaAutoId)
VALUES ('X7', 140000, 5);
-- Generar 100 Solicitudes aleatoreas
DECLARE @i INT = 1;
WHILE @i <= 100 BEGIN
INSERT INTO Solicitudes (Cantidad, Fecha, ModeloAutoId, VendedorId)
VALUES (
        FLOOR(RAND() * 10) + 1,
        DATEADD(DAY, - @i, GETDATE()),
        FLOOR(RAND() * 25) + 1,
        FLOOR(RAND() * 10) + 1
    );
SET @i = @i + 1;
END;
--3 marcas más solicitadas, cantidad de solicitudes de cada una y orden descendente.
SELECT TOP 3 SUM(Solicitudes.Cantidad) AS TotalQuantity,
    MarcaAuto.Nombre
FROM Solicitudes
    INNER JOIN ModeloAuto ON Solicitudes.ModeloAutoId = ModeloAuto.ModeloAutoId
    INNER JOIN MarcaAuto ON ModeloAuto.MarcaAutoId = MarcaAuto.MarcaAutoId
GROUP BY MarcaAuto.Nombre
ORDER BY TotalQuantity DESC;
--Obtener solicitudes del mes actual. 
SELECT *
FROM Solicitudes
WHERE YEAR(Solicitudes.Fecha) = YEAR(GETDATE())
    AND MONTH(Solicitudes.Fecha) = MONTH(GETDATE());
--Vendedor con menos solicitudes en los últimos 30 días. 
SELECT TOP 1 Solicitudes.VendedorId,
    COUNT(Solicitudes.VendedorId) AS TotalSolicitudes,
    Vendedor.Nombre
FROM Solicitudes
    INNER JOIN Vendedor ON Solicitudes.VendedorId = Vendedor.VendedorId
WHERE Solicitudes.Fecha BETWEEN DATEADD(DAY, -30, GETDATE())
    AND GETDATE()
GROUP BY Solicitudes.VendedorId,
    Vendedor.Nombre
ORDER BY TotalSolicitudes ASC;
--Modelos que no tengan solicitudes.
SELECT COUNT(Solicitudes.ModeloAutoId) AS TotalSolicitudes,
    ModeloAuto.Nombre
FROM Solicitudes
    INNER JOIN ModeloAuto ON Solicitudes.ModeloAutoId = ModeloAuto.ModeloAutoId
GROUP BY Solicitudes.ModeloAutoId,
    ModeloAuto.Nombre
HAVING COUNT(Solicitudes.ModeloAutoId) = 0;
--3 meses con mas ventas.
SELECT TOP 3 SUM(Solicitudes.Cantidad * ModeloAuto.Precio) AS Total,
    YEAR(Solicitudes.Fecha) AS Año,
    MONTH(Solicitudes.Fecha) AS Mes
FROM Solicitudes
    INNER JOIN ModeloAuto ON Solicitudes.ModeloAutoId = ModeloAuto.ModeloAutoId
GROUP BY YEAR(Solicitudes.Fecha),
    MONTH(Solicitudes.Fecha)
ORDER BY Total DESC;