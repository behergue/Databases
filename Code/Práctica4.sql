--Práctica 4
-- Beatriz Herguedas Pinedo, Pablo Hernández Aguado


--Apartado 1:

CREATE TABLESPACE EMPRESADG10 DATAFILE 'D:\oracle\EMPRESADG10' SIZE 100M AUTOEXTEND OFF;
CREATE USER DG10 IDENTIFIED BY DG10PWD DEFAULT TABLESPACE EMPRESADG10 TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON EMPRESADG10;
GRANT CREATE SESSION, CREATE TABLE, DELETE ANY TABLE, SELECT ANY DICTIONARY, CREATE ANY SEQUENCE TO DG10;


-- Salida:
-- TABLESPACE EMPRESADG10 creado.
-- User DG10 creado.
-- Grant correcto.

-- Apartado 2:

CREATE TABLE Empleados (
    Nombre Char(50), 
    DNI Char(9), 
    Sueldo Number(6,2),

    PRIMARY KEY (DNI),

    CHECK ((Sueldo BETWEEN 735.90 AND 5000.00) OR (Sueldo IS NULL))
);
    
CREATE TABLE Domicilios (
    DNI Char(9), 
    Calle Char(50), 
    "Código postal" Char(5),

    PRIMARY KEY (DNI, Calle, "Código postal"),

    FOREIGN KEY (DNI) 
        REFERENCES Empleados(DNI)
        ON DELETE CASCADE,
    FOREIGN KEY ("Código postal") 
        REFERENCES "Códigos postales"("Código postal")
        ON DELETE NO ACTION
);
    
CREATE TABLE Teléfonos (
    DNI Char(9) , 
    Teléfono Char(9),

    PRIMARY KEY (DNI, Teléfono),

    FOREIGN KEY (DNI) 
        REFERENCES Empleados(DNI)
        ON DELETE CASCADE
);
    
CREATE TABLE "Códigos postales" (
    "Código postal" Char(5), 
    Población Char(50), 
    Provincia Char(50),

    PRIMARY KEY ("Código postal")
);

-- Apartado 3:

-- EMPLEADOS --
-- Tuplas válidas.
INSERT INTO Empleados VALUES ('Juan', '12345678A', 1200.00);
INSERT INTO Empleados VALUES ('Marí­a', '12345678B', 1500.00);
INSERT INTO Empleados VALUES ('Pedro', '12345678C', 2300.00);
INSERT INTO Empleados VALUES ('Miguel', '12345678D');
-- Clave primaria repetida.
-- 1 --
INSERT INTO Empleados VALUES ('Fake Juan', '12345678A', 1200.00);
-- Faltan columnas que no pueden ser nulas.
-- 2 --
INSERT INTO Empleados VALUES ('NoID Juan', , 1200.00);
-- Restricciones de sueldo.
-- 3 --
INSERT INTO Empleados VALUES ('Inés', '12345678E', 730.00);
INSERT INTO Empleados VALUES ('Antonio', '12345678F', 5001.00);

-- CÓDIGOS POSTALES --
INSERT INTO "Códigos postales" VALUES ('00401', 'Vitoria', 'País Vasco');
INSERT INTO "Códigos postales" VALUES ('00512', 'Gandía', 'Alicante');
INSERT INTO "Códigos postales" VALUES ('00612', 'Conil', 'Cádiz');
INSERT INTO "Códigos postales" VALUES ('02008', 'Ibiza', 'Islas Baleares');
INSERT INTO "Códigos postales" VALUES ('00123', 'Villarobledo', 'Albacete');
-- Clave primaria repetida.
-- 1 --
INSERT INTO "Códigos postales" VALUES ('00512', 'Sabadell', 'Barcelona');
-- Faltan columnas que no pueden ser nulas.
-- 2 --
INTO "Códigos postales" VALUES ( , 'Fuenlabrada', 'Madrid');

-- DOMICILIOS --
-- Tuplas válidas.
INSERT INTO Domicilios VALUES ('12345678A', 'C/ Avión, 12', '00401');
INSERT INTO Domicilios VALUES ('12345678A', 'C/ Barco, 13', '00401');
INSERT INTO Domicilios VALUES ('12345678B', 'C/ Autobús, 07', '00512');
INSERT INTO Domicilios VALUES ('12345678B', 'C/ Autobús, 07', '00612');
INSERT INTO Domicilios VALUES ('12345678C', 'C/ Tranví­a, 19', '02008');
-- Clave primaria repetida.
-- 1 --
INSERT INTO Domicilios VALUES ('12345678A', 'C/ Jet, 15', '00402');
-- Faltan columnas que no pueden ser nulas.
-- 2 --
INTO "Códigos postales" VALUES ( , 'C/ Motor, 5', '00432');
-- Violación integridad referencial (NOT IN Empleados)
-- 4 --
INSERT INTO Domicilios VALUES ('12345678G', 'C/ Metro, 12', '00123');
-- Violación integridad referencial (NOT IN "Códigos postales")
-- 4 --
INSERT INTO Domicilios VALUES ('12345678A', 'C/ Coche, 12', '98765');

-- TELÉFONOS --
-- Tuplas válidas.
INSERT INTO Teléfonos VALUES ('12345678A', '912486529');
INSERT INTO Teléfonos VALUES ('12345678A', '618594326');
INSERT INTO Teléfonos VALUES ('12345678B', '748569753');
INSERT INTO Teléfonos VALUES ('12345678B', '658753221');
INSERT INTO Teléfonos VALUES ('12345678C', '682946723');
INSERT INTO Teléfonos VALUES ('12345678C', '789426589');
-- Clave primaria repetida.
-- 1 --
INSERT INTO Teléfonos VALUES ('12345678A', '912111529');
-- Faltan argumentos.
-- 2 --
INSERT INTO Teléfonos VALUES ('12345678I', );
-- Violación integridad referencial. (NOT IN Empleados)
-- 4 --
INSERT INTO Teléfonos VALUES ('12345678H', '989898989');


-- BORRADOS --
-- Se borra el código postal '00512'.
-- 5 --
DELETE FROM "Códigos postales" WHERE "Código postal" = '00512';
-- -- No debe borrarse ninguna tupla ni en "Códigos postales" ni
-- en "Domicilios".

-- Se borra el empleado con DNI '12345678C'.
-- 6 --
DELETE FROM Empleados WHERE DNI = '12345678C';
-- -- Deben borrarse sus tuplas asociadas de "Domicilios" y "Teléfonos".
SELECT * FROM Domicilios WHERE DNI = '12345678C';
SELECT * FROM Teléfonos WHERE DNI = '12345678C';

-- La relación "Teléfonos" no tiene ON DELETE SET NULL.
-- 7 ¿? --

-- Apartado 4:

LOAD DATA
INFILE 'Códigos postales.txt'
APPEND
INTO TABLE "Códigos postales"
FIELDS TERMINATED BY ';'
("Código postal", Población, Provincia)

LOAD DATA
INFILE 'Domicilios.txt'
APPEND
INTO TABLE Domicilios
FIELDS TERMINATED BY ';'
(DNI, Calle, "Código postal")

LOAD DATA
INFILE 'Empleados.txt'
APPEND
INTO TABLE Empleados
FIELDS TERMINATED BY ';'
(Nombre, DNI, Sueldo)

LOAD DATA
INFILE 'Teléfonos.txt'
APPEND
INTO TABLE Teléfonos
FIELDS TERMINATED BY ';'
(DNI, Teléfono)

-- Apartado 5:

-- VISTA 1 --
CREATE VIEW vista1 AS 
SELECT Nombre, Calle, "Código postal"
FROM Empleados NATURAL JOIN Domicilios
ORDER BY "Código postal", Nombre;

-------------

-- VISTA 2 --
CREATE VIEW vista2 AS
SELECT Nombre, DNI, Calle, "Código postal", Teléfono
FROM (Empleados NATURAL JOIN Teléfonos) 
    NATURAL LEFT OUTER JOIN Domicilios
ORDER BY Nombre;

-------------

-- VISTA 3 --
CREATE VIEW vista3 AS
SELECT Nombre, DNI, Calle, "Código postal", Teléfono
FROM (Empleados NATURAL LEFT OUTER JOIN Teléfonos) 
    NATURAL LEFT OUTER JOIN Domicilios
ORDER BY Nombre;

-------------

-- VISTA 4 --
CREATE VIEW vista4 AS
SELECT Nombre, DNI, Calle, Población, Provincia, "Código postal"
FROM Empleados NATURAL LEFT OUTER JOIN 
    (Domicilios NATURAL JOIN "Códigos postales")
ORDER BY Nombre;

-------------

-- VISTA 5 --
CREATE VIEW vista5 AS
SELECT Nombre, Empleados.DNI, Calle, Población, Provincia, "Código postal", Teléfono
FROM (Empleados NATURAL LEFT OUTER JOIN (
    (Domicilios NATURAL JOIN "Códigos postales")))
  NATURAL JOIN
    (Empleados NATURAL LEFT OUTER JOIN Teléfonos)
ORDER BY Nombre;

-------------

-- VISTA 6 --
UPDATE Empleados
SET Sueldo = Sueldo*1.10
WHERE Sueldo*1.10 <= 1900.00;

-------------

-- VISTA 7 --
UPDATE Empleados
SET Sueldo = Sueldo/1.10
WHERE Sueldo <= 1900.00;

-- -- Válido porque sólo cambian los sueldos 1000 y 1500,
-- quedando menores que 1900; mientras que los otros 2 que
-- no cambian, 5000 y 2000, son mayores de 1900, por lo que
-- para deshacer el update basta con la condición del WHERE.

-------------

-- VISTA 8 --
UPDATE Empleados
SET Sueldo = Sueldo*1.10
WHERE Sueldo*1.10 <= 1600.00;

--UPDATE Empleados
--SET Sueldo = Sueldo/1.10
--WHERE Sueldo <= 1600.00;

-- -- La acción anterior no es válida, pues se actualiza
-- únicamente el sueldo de 1500, quedando mayor que 1600 
-- (1650); por lo que al deshacer, no podríamos saber si
-- ese sueldo (1650) ha sido aumentado anteriormente o no.
-- Recuperamos la relación original con:

UPDATE Empleados
SET Sueldo = Sueldo/1.10
WHERE DNI = '12345678L';

-------------

-- VISTA 9 --
CREATE VIEW vista9 AS
SELECT 
    COUNT(*) AS Empleados, 
    MIN(Sueldo) AS "Sueldo mínimo",
    MAX(Sueldo) AS "Sueldo máximo",
    AVG(Sueldo) AS "Sueldo medio"
FROM Empleados;

-------------

-- VISTA 10 --
CREATE VIEW vista10 AS
SELECT 
    AVG(Sueldo) AS "Sueldo medio", 
    COUNT(*) AS "Número empleados", 
    Población
FROM Empleados NATURAL LEFT OUTER JOIN 
    (Domicilios NATURAL JOIN "Códigos postales")
GROUP BY Población
ORDER BY Población;

-------------

-- VISTA 11 --
CREATE VIEW vista11 AS
SELECT Nombre, DNI, Teléfono
FROM Empleados NATURAL JOIN Teléfonos
WHERE DNI IN (
  SELECT DNI
  FROM Empleados NATURAL JOIN Teléfonos
  GROUP BY DNI
  HAVING COUNT(*) > 1
);

-------------

-- VISTA 12 --
CREATE VIEW vista12 AS
SELECT *
FROM "Códigos postales"
PIVOT (
    "Código postal"
    FOR Provincia IN (
        'Barcelona', 'Córdoba',
        'Madrid', 'Zaragoza'
    )
)
ORDER BY Población;

-------------