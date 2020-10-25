-- Práctica 7
-- Beatriz Herguedas Pinedo, Pablo Hernández Aguado

-- Apartado 1:

CREATE TABLE cuentas (
    numero NUMBER PRIMARY KEY,
    saldo NUMBER NOT NULL
);

INSERT INTO cuentas VALUES (123, 400);
INSERT INTO cuentas VALUES (456, 300);

COMMIT;


--Salida: 
--
--Table CUENTAS creado.
--
--
--1 fila insertadas.
--
--
--1 fila insertadas.
--
--Confirmación terminada.


-- TERMINAL T1

--c:\hlocal>sqlplus
--
--SQL*Plus: Release 11.2.0.1.0 Production on MiÚ Dic 19 18:22:59 2018
--
--Copyright (c) 1982, 2010, Oracle.  All rights reserved.
--
--Introduzca el nombre de usuario: DG10@BDd/DG10PWD
--
--Conectado a:
--Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
--With the Partitioning, OLAP, Data Mining and Real Application Testing options
--
--SQL> SET AUTOCOMMIT OFF;
--SQL> UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;
--
--1 fila actualizada.

-- TERMINAL T2

--c:\hlocal>sqlplus
--
--SQL*Plus: Release 11.2.0.1.0 Production on MiÚ Dic 19 18:24:57 2018
--
--Copyright (c) 1982, 2010, Oracle.  All rights reserved.
--
--Introduzca el nombre de usuario: DG10@BDd/DG10PWD
--
--Conectado a:
--Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
--With the Partitioning, OLAP, Data Mining and Real Application Testing options
--
--SQL> SET AUTOCOMMIT OFF;
--
--SQL> SELECT saldo FROM cuentas WHERE numero = 123;
--
--     SALDO
------------
--       400

-- TERMINAL T1

--SQL> COMMIT;
--
--Confirmaci¾n terminada.


-- TERMINAL T2.

--SQL> SELECT saldo FROM cuentas WHERE numero = 123;
--
--     SALDO
------------
--       500

-- --- ---- --- --

-- Apartado 2:

-- Al hacer UPDATE, inicialmente no se ha hecho COMMIT, por lo que el cambio no ha sido confirmado.
-- Por tanto, al consultar el saldo de la cuenta en T2, este no se ha actualizado (400).
-- Al hacer COMMIT en T1, se confirma la actualización, y al consultar en T2 se muestra el saldo acutalizado (500).

-- TERMINAL 2 --

--SQL> SET AUTOCOMMIT OFF;

-- TERMINAL 1 --

--SQL> UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;
--
--1 fila actualizada.

-- TERMINAL 2 --

--SQL> UPDATE cuentas SET saldo = saldo + 200 WHERE numero = 123;
--      (se muestra línea en blanco .... esperando)

-- > T2 no puede hacer el UPDATE, porque hay un UPDATE en T1 (sobre esa tupla )que no ha sido COMMITeado.

-- TERMINAL 1 --

--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- TERMINAL 2 --

--  (se desbloquea)
--1 fila actualizada.
--
--SQL>

-- TERMINAL 1 -- 

--SQL> SELECT saldo FROM cuentas WHERE numero = 123;
--
--     SALDO
------------
--       600

-- > Sólo se ha tenido en cuenta el UPDATE (+100) que ha sido commiteado en T1.

-- TERMINAL 2 --

--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- TERMINAL 1 --

--SQL> SELECT saldo FROM cuentas WHERE numero = 123;
--
--     SALDO
------------
--       800

-- > Como se ha hecho COMMIT en T2, se ha tenido en cuenta su UPDATE (+200)

-- Apartado 3:

-- TERMINAL 1 --

--SQL> UPDATE cuentas SET saldo = saldo + 100 WHERE numero = 123;
--
--1 fila actualizada.

-- TERMINAL 2 --

--SQL> UPDATE cuentas SET saldo = saldo + 200 WHERE numero = 456;
--
--1 fila actualizada.

-- TERMINAL 1 --

--SQL> UPDATE cuentas SET saldo = saldo + 300 WHERE numero = 456;
--      (se queda esperando)

-- > Queda bloqueado por el UPDATE sobre la tupla (numero = 456) de T2 sin COMMIT.

-- TERMINAL 2 --

--SQL> UPDATE cuentas SET saldo = saldo + 400 WHERE numero = 123;
--      (se queda esperando)

-- > Queda bloqueado por el UPDATE sobre la tupla (numero = 123) de T1 sin COMMIT.

-- TERMINAL 1 --

--UPDATE cuentas SET saldo = saldo + 300 WHERE numero = 456
--       *
--ERROR en lÝnea 1:
--ORA-00060: detectado interbloqueo mientras se esperaba un recurso
--
--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- TERMINAL 2 --

--
--1 fila actualizada.
--
--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- ACTUALIZACIONES DE SALDOS --

-- numero = 123 : 800 + 100 + 400 = 1300;
-- numero = 456 : 300 + 200 = 500;

-- El segundo UPDATE de '456' en T1 ha quedado abortado tras hacer el
-- segundo UPDATE de '123' en T2 (T2 quedó bloqueada esperando y T1 se desbloqueó
-- mostrando un error al hacer el UPDATE).

-- Apartado 4:

-- TERMINAL 1 --

--SQL> ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;
--
--Sesi¾n modificada.
--
--SQL> SELECT SUM(saldo) FROM cuentas;
--
--SUM(SALDO)
------------
--      1800

-- > Comportamiento usual, suma de saldos = 1300 + 500 = 1800;

-- TERMINAL 2 --

--SQL> UPDATE cuentas SET saldo = saldo + 100;
--
--2 filas actualizadas.
--
--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- > Comportamiento usual, se actualiza (con COMMIT) el saldo de ambas cuentas.

-- TERMINAL 1 --

--SQL> SELECT SUM(saldo) FROM cuentas;
--
--SUM(SALDO)
------------
--      1800

-- > La suma de los saldos es igual que la anterior, pues el UPDATE de T2 ha sido "bloqueado"
-- > por el nivel de aislamiento de la sesión T1 (serializable).

-- TERMINAL 1 --

--SQL> ALTER SESSION SET ISOLATION_LEVEL = READ COMMITTED;
--
--Sesi¾n modificada.
--
--SQL> SELECT SUM(saldo) FROM cuentas;
--
--SUM(SALDO)
------------
--      2000

-- > Al modificar el nivel de aislamiento de T1 a "read committed",
-- > las tablas de T1 se actualizan con los cambios confirmados (commit) de T2.
-- > Por tanto, los nuevos saldos de las cuentas '123' y '456' son 1400 y 600 respectivamente.

-- TERMINAL 2 --

--SQL> UPDATE cuentas SET saldo=saldo +100;
--
--2 filas actualizadas.
--
--SQL> COMMIT;
--
--Confirmaci¾n terminada.

-- TERMINAL 1 --

--SQL> SELECT SUM(saldo) FROM cuentas;
--
--SUM(SALDO)
------------
--      2200

-- > Se ha hecho un UPDATE confirmado en T2, por lo que los cambios se
-- > han visto reflejados en T1, cuyo nivel de aislamiento ya había sido
-- > modificado a (read commited), el predeterminado de las sesiones de SQL.

-- Apartado 5:

CREATE TABLE butacas(
    id number(8) primary key,
    evento varchar(30),
    fila varchar(10),
    columna varchar(10)
);

CREATE TABLE reservas(
    id number(8) primary key,
    evento varchar(30),
    fila varchar(10),
    columna varchar(10)
);

-- Salida:

-- Table BUTACAS creado.
-- 
-- 
-- Table RESERVAS creado.
-- 
-- 
-- Table BUTACAS creado.
-- 
-- 
-- Table RESERVAS creado.


INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','1');
INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','2');
INSERT INTO butacas VALUES (Seq_Butacas.NEXTVAL,'Circo','1','3');
COMMIT;

-- Salida:

--1 fila insertadas.
--
--
--1 fila insertadas.
--
--
--1 fila insertadas.
--
--Confirmación terminada.

-- SCRIPT.sql --

-- Salida (primera reserva):

--INFO: Se intenta reservar.
--
--Procedimiento PL/SQL terminado correctamente.
--
--SCRIPT_COL                             
-----------------------------------------
--"C:\hlocal\BD\scripts\preguntar.sql"
--
--
--V_ERROR
----------------------------------------------------------------------------------
--false
--
--'¿Confirmar la reserva?'
--s
--INFO: Localidad reservada.
--
--Procedimiento PL/SQL terminado correctamente.
--Confirmación terminada.



-- Salida (segunda reserva): 


--ERROR: La localidad ya está reservada.
--
--Procedimiento PL/SQL terminado correctamente.
--
--SCRIPT_COL                             
-----------------------------------------
--"C:\hlocal\BD\scripts\no_preguntar.sql"
--
--
--V_ERROR
----------------------------------------------------------------------------------
--true 
--
--n
--INFO: No se ha reservado la localidad.
--
--Procedimiento PL/SQL terminado correctamente.
--Confirmación terminada.



-- Salida (tercera reserva) :

--ERROR: No existe esa localidad.
--
--Procedimiento PL/SQL terminado correctamente.
--
--SCRIPT_COL                             
-----------------------------------------
--"C:\hlocal\BD\scripts\no_preguntar.sql"
--
--
--V_ERROR
----------------------------------------------------------------------------------
--true 
--
--n
--INFO: No se ha reservado la localidad.
--
--Procedimiento PL/SQL terminado correctamente.
--Confirmación terminada.

-- PUNTOS 6 Y 7 --


-- Salida 1:

--INFO: Se intenta reservar.
--
--Procedimiento PL/SQL terminado correctamente.
--
--SCRIPT_COL                             
-----------------------------------------
--"C:\hlocal\BD\scripts\preguntar.sql"
--
--
--V_ERROR
----------------------------------------------------------------------------------
--false
--
--'¿Confirmar la reserva?'
--s
--INFO: Localidad reservada.
--
--Procedimiento PL/SQL terminado correctamente.
--Confirmación terminada.
--

-- Salida 2:

--INFO: Se intenta reservar.
--
--Procedimiento PL/SQL terminado correctamente.
--
--SCRIPT_COL                             
-----------------------------------------
--"C:\hlocal\BD\scripts\preguntar.sql"
--
--
--V_ERROR
----------------------------------------------------------------------------------
--false
--
--'¿Confirmar la reserva?'
--s
--INFO: Localidad reservada.

-- > PROBLEMA: Las 2 sesiones han podido reservar la misma plaza. En particular, la
-- > la primera sesión ha podido reservar la plaza después de que la segunda sesión
-- > ya la hubiera reservado (confirmó antes).





-- PUINTO FINAL --


Procedimiento PL/SQL terminado correctamente.

SCRIPT_COL                             
---------------------------------------
"C:\hlocal\BD\scripts\preguntar.sql"


V_ERROR
--------------------------------------------------------------------------------
false

'¿Confirmar la reserva?'
s
INFO: Localidad reservada.

Procedimiento PL/SQL terminado correctamente.
Confirmación terminada.





Procedimiento PL/SQL terminado correctamente.

SCRIPT_COL                             
---------------------------------------
"C:\hlocal\BD\scripts\preguntar.sql"


V_ERROR
--------------------------------------------------------------------------------
false

'¿Confirmar la reserva?'
s
INFO: No se ha reservado la localidad.

Procedimiento PL/SQL terminado correctamente.
Confirmación terminada.