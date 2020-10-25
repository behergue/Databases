-- Pr·ctica 6
-- Beatriz Herguedas Pinedo, Pablo Hern·ndez Aguado

-- Apartado 1:

CREATE OR REPLACE TABLE pedidos (
    cÛdigo VARCHAR(6),
    fecha VARCHAR(10),
    importe NUMBER(6,2),
    cliente VARCHAR(20),
    notas VARCHAR(1024),

    PRIMARY KEY (cÛdigo)
);

CREATE OR REPLACE TABLE contiene (
    pedido VARCHAR(6),
    plato VARCHAR(20),
    precio NUMBER(6,2),
    unidades NUMBER(2,0),

    PRIMARY KEY(pedido, plato)
);

CREATE OR REPLACE TABLE auditorÌa (
    operaciÛn VARCHAR(6),
    tabla VARCHAR(50),
    fecha VARCHAR(10),
    hora VARCHAR(8)

    -- NO PRIMARY KEY.
);


-- Salida: 
--
--Table PEDIDOS creado.
--
--
--Table CONTIENE creado.
--
--
--Table AUDITOR√ùA creado.

-- Apartado 2:

CREATE VIEW pedido_cliente(cÛdigo, cliente) AS
    SELECT cÛdigo, cliente
    FROM pedidos;
    
CREATE INDEX index_vista
    ON pedido_cliente (cliente);

-- Salida:
--
--View PEDIDO_CLIENTE creado.
--
--Error que empieza en la lÌnea: 5 del comando :
--CREATE INDEX index_vista
--    ON pedido_cliente (cliente)
--Informe de error -
--ORA-01702: una vista no es apropiada aquÌ
--01702. 00000 -  "a view is not appropriate here"
--*Cause:    Among other possible causes, this message will be produced if an
--           attempt was made to define an Editioning View over a view.
--*Action:   An Editioning View may only be created over a base table.

CREATE MATERIALIZED VIEW pedido_cliente_mat(cÛdigo, cliente) AS
    SELECT cÛdigo, cliente
    FROM pedidos;
    
CREATE INDEX index_vista_mat
    ON pedido_cliente_mat (cliente);


-- Salida:
--
--Materialized view PEDIDO_CLIENTE_MAT creado.
--
--
--Index INDEX_VISTA_MAT creado.

-- CONCLUSI”N:
-- No se pueden crear Ìndices para vistas, pero sÌ para
-- vista materializadas.

-- Apartado 3:

CREATE INDEX index_pedidos
  ON pedidos (cliente);

-- Salida:
--
--Index INDEX_PEDIDOS creado.

BEGIN
  
  FOR I IN 1...500000
  LOOP
    INSERT INTO pedidos VALUES
      (to_char(I), '06/01/2015', 10.0, 'C' || to_char(I), ' ');
  END LOOP;

END;

-- Salida:
--
--Procedimiento PL/SQL terminado correctamente.


SET TIMING ON;

SELECT *
FROM pedidos
WHERE cliente = 'C500000';

DROP INDEX index_pedidos;

SELECT *
FROM pedidos
WHERE cliente = 'C500000';

-- Salida:
--
--C”DIGO FECHA         IMPORTE CLIENTE              NOTAS
-------- ---------- ---------- -------------------- ------------∑∑∑
--500000 06/01/2015         10 C500000              
--
--Transcurrido: 00:00:00.071
--
--
--Index INDEX_PEDIDOS borrado.
--
--Transcurrido: 00:00:00.757
--
--
--C”DIGO FECHA         IMPORTE CLIENTE              NOTAS
-------- ---------- ---------- -------------------- ------------∑∑∑
--500000 06/01/2015         10 C500000              
--
--Transcurrido: 00:00:00.369

-- Apartado 4:

CREATE OR REPLACE TRIGGER trigger_contiene

AFTER INSERT OR DELETE OR UPDATE ON contiene

FOR EACH ROW

BEGIN

  IF INSERTING THEN
    UPDATE pedidos
    SET pedidos.importe = pedidos.importe + (:NEW.precio * :NEW.unidades)
    WHERE pedidos.cÛdigo = :NEW.pedido;
  END IF;

  IF DELETING THEN
    UPDATE pedidos
    SET pedidos.importe = pedidos.importe - (:OLD.precio * :OLD.unidades)
    WHERE pedidos.cÛdigo = :OLD.pedido;
  END IF;

  IF UPDATING THEN
    UPDATE pedidos
    SET pedidos.importe = pedidos.importe 
        - (:OLD.precio * :OLD.unidades)
    WHERE pedidos.cÛdigo = :OLD.pedido;

    UPDATE pedidos
    SET pedidos.importe = pedidos.importe 
        - (:NEW.precio * :NEW.unidades)
    WHERE pedidos.cÛdigo = :NEW.pedido;
  END IF;

END;


-- Salida:
--
--Trigger TRIGGER_CONTIENE compilado

-- Apartado 5:

CREATE OR REPLACE TRIGGER trigger_pedidos

AFTER INSERT OR DELETE OR UPDATE ON pedidos

BEGIN

  IF INSERTING THEN
    INSERT INTO auditorÌa VALUES
      ('INSERT', 'pedidos', to_char(sysdate, 'dd/mm/yyyy'), to_char(sysdate, 'hh:mi:ss'));
  END IF;

  IF DELETING THEN
    INSERT INTO auditorÌa VALUES
      ('DELETE', 'pedidos', to_char(sysdate, 'dd/mm/yyyy'), to_char(sysdate, 'hh:mi:ss'));
  END IF;

  IF UPDATING THEN
    INSERT INTO auditorÌa VALUES
      ('UPDATE', 'pedidos', to_char(sysdate, 'dd/mm/yyyy'), to_char(sysdate, 'hh:mi:ss'));
  END IF;

END;


-- Salida:
--
--Trigger TRIGGER_PEDIDOS compilado