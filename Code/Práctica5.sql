-- Pr�ctica 5
-- Beatriz Herguedas Pinedo, Pablo Hern�ndez Aguado

CREATE TABLE "C�digos postales I" (
    "C�digo postal" VARCHAR(5), 
    Población VARCHAR(50), 
    Provincia VARCHAR(50)
);
    
CREATE TABLE "Domicilios I" (
    DNI VARCHAR(9), 
    Calle VARCHAR(50), 
    "C�digo postal" VARCHAR(5)
);

-- Salida:
--
--Table "C�digos postales I" creado.
--
--
--Table "Domicilios I" creado.

--Apartado 2:

SET SERVEROUTPUT ON SIZE 100000;

-- Actualizaci�n previa.
UPDATE "C�digos postales I"
SET "C�digo postal" = '14900'
WHERE "C�digo postal" IS NULL;


CREATE PROCEDURE comprobar_FK (lim_tuplas) IS

    CURSOR cursorDom IS
        SELECT *
        FROM "Domicilios I";

    CURSOR cursorFK IS
        SELECT DISTINCT "C�digo postal"
        FROM "C�digos postales I";
    
    regDom cursorDom%ROWTYPE;
    regFK cursorFK%ROWTYPE;

    referenced BOOLEAN;
    numFKunref INT := 0;
    

    FK_UNREF EXCEPTION;

BEGIN
    DBMS_OUTPUT.PUT_LINE (
        'Se comprueba la integridad referencia de la tabla '
        || '"Domicilios I" respecto a la tabla "C�digos postales I":'
        );
    DBMS_OUTPUT.PUT_LINE('');
    
    OPEN cursorDom;
    LOOP
        FETCH cursorDom INTO regDom;
        EXIT WHEN cursorDom%NOTFOUND;

        -- Se comprueba la referencia
        OPEN cursorFK;
        referenced := FALSE;
        LOOP
            FETCH cursorFK INTO regFK;
            EXIT WHEN cursorFK%NOTFOUND OR referenced;

            IF regDom."C�digo postal" = regFK."C�digo postal" THEN
                
                referenced := TRUE;

            END IF;

        END LOOP;
        CLOSE cursorFK;

        -- Se muestran las tuplas no referenciadas (hasta el l�mite).
        IF NOT referenced THEN

            numFKunref := numFKunref + 1;

            IF numFKunref <= lim_tuplas THEN
                DBMS_OUTPUT.PUT_LINE(
                    regDom.Dni || ', ' 
                    || regDom.Calle || ', '
                    || regDom."C�digo postal" || ';'
                    );
            END IF;

        END IF;

    END LOOP;
    CLOSE cursorDom;
    DBMS_OUTPUT.PUT_LINE('');

    IF numFKunref > 0 THEN
        RAISE FK_UNREF;    
    ELSE
        DBMS_OUTPUT.PUT_LINE (
            'No hay violaci�n de integridad referencial.'
        );
    END IF;
    DBMS_OUTPUT.PUT_LINE('');

EXCEPTION
    WHEN FK_UNREF THEN
        DBMS_OUTPUT.PUT_LINE (
            'Hay ' || numFKunref || ' tuplas que violan la integridad referencial.'
        );
        DBMS_OUTPUT.PUT_LINE (
            'Se muestra un m�ximo de ' || lim_tuplas || ' tuplas.'
        );

END;

EXECUTE comprobar_FK(0);
EXECUTE comprobar_FK(5);

-- Salida:
--
--Procedure COMPROBAR_FK compilado
--
--Procedimiento PL/SQL terminado correctamente.
--Se comprueba la integridad referencia de la tabla "Domicilios I" respecto a la tabla "C�digos postales I":
--
--12345678P, Carb�n, 14901;
--
--Hay 1 tuplas que violan la integridad referencial.
--Se muestra un m�ximo de 5 tuplas.
--
--Procedimiento PL/SQL terminado correctamente.

-- Apartado 3:

SET SERVEROUTPUT ON SIZE 100000;

CREATE PROCEDURE comprobar_NULL IS

    CURSOR cursorNulos IS
        SELECT *
        FROM "C�digos postales I"
        WHERE "C�digo postal" IS NULL
            OR Poblaci�n IS NULL
            OR Provincia IS NULL;
    
    regNulos cursorNulos%ROWTYPE;
    numMal INT := 0;

    TUPLAS_INCORRECTAS EXCEPTION;

BEGIN
    DBMS_OUTPUT.PUT_LINE (
        'Se comprueba la existencia de valores nulos'
        || 'en las tuplas de "C�digos postales I":'
        );
    DBMS_OUTPUT.PUT_LINE('');
    
    OPEN cursorNulos;
    LOOP
        FETCH cursorNulos INTO regNulos;
        EXIT WHEN cursorNulos%NOTFOUND;

        numMal := numMal + 1;

        DBMS_OUTPUT.PUT_LINE(
            regNulos."C�digo postal" || ', ' 
            || regNulos.Poblaci�n || ', '
            || regNulos.Provincia || ';'
            );
    END LOOP;
    CLOSE cursorNulos;
    DBMS_OUTPUT.PUT_LINE('');

    IF numMal > 0 THEN
        RAISE TUPLAS_INCORRECTAS;    
    ELSE
        DBMS_OUTPUT.PUT_LINE (
            'No hay ninguna tupla con valores nulos.'
        );
    END IF;
    DBMS_OUTPUT.PUT_LINE('');

EXCEPTION
    WHEN TUPLAS_INCORRECTAS THEN
        DBMS_OUTPUT.PUT_LINE (
            'Hay ' || numMal || ' tupla(s) incorrecta(s).'
        );

END;

EXECUTE comprobar_NULL;


-- Salida: 
--
--Procedure COMPROBAR_NULL compilado
--
--Se comprueba la existencia de valores nulosen las tuplas de "C�digos postales I":
--
--, Arganda, Sevilla;
--
--Hay 1 tupla(s) incorrecta(s).
--
--Procedimiento PL/SQL terminado correctamente.

-- Apartado 4:

SET SERVEROUTPUT ON SIZE 100000;


CREATE PROCEDURE comprobar_PK IS

    CURSOR cursorCP IS
        SELECT *
        FROM "C�digos postales I";

    CURSOR cursorPK IS
        SELECT DISTINCT "C�digo postal"
        FROM "C�digos postales I";
    
    regPK cursorPK%ROWTYPE;

    regCP cursorCP%ROWTYPE;
    t_regCP cursorCP%ROWTYPE;

    numPKrep INT := 0;
    numPKnull INT := 0;
    numPKtup INT;

    PK_REP EXCEPTION;

BEGIN
    DBMS_OUTPUT.PUT_LINE (
        'Se comprueba la existencia de claves primarias '
        || 'repetidas en la tabla "C�digos postales I":'
        );
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Claves primarias repetidas.
    OPEN cursorPK;
    LOOP
        FETCH cursorPK INTO regPK;
        EXIT WHEN cursorPK%NOTFOUND;

        OPEN cursorCP;
        numPKtup := 0;
        LOOP
            FETCH cursorCP INTO regCP;
            EXIT WHEN cursorCP%NOTFOUND;

            IF regCP."C�digo postal" = regPK."C�digo postal" THEN
                
                numPKtup := numPKtup + 1;

                IF numPKtup = 1 THEN
                    t_regCP := regCP;
                ELSE -- Necesariamente > 1.
                    DBMS_OUTPUT.PUT_LINE(
                        regCP."C�digo postal" || ', ' 
                        || regCP.Poblaci�n || ', '
                        || regCP.Provincia || ';'
                        );
                END IF;

            END IF;

        END LOOP;
        CLOSE cursorCP;

        -- Si se repite la clave, al final se muestra la 1a tupla encontrada.
        IF numPKtup > 1 THEN

            DBMS_OUTPUT.PUT_LINE(
                t_regCP."C�digo postal" || ', ' 
                || t_regCP.Poblaci�n || ', '
                || t_regCP.Provincia || ';'
                );
            DBMS_OUTPUT.PUT_LINE('');

            numPKrep := numPKrep + 1;

        END IF;
        
    END LOOP;
    CLOSE cursorPK;

    -- Claves primarias nulas.
    OPEN cursorCP;
        LOOP
            FETCH cursorCP INTO regCP;
            EXIT WHEN cursorCP%NOTFOUND;

            IF regCP."C�digo postal" IS NULL THEN
                
                numPKnull := numPKnull + 1;
                
                DBMS_OUTPUT.PUT_LINE(
                    regCP."C�digo postal" || ', ' 
                    || regCP.Poblaci�n || ', '
                    || regCP.Provincia || ', '
                    );
            END IF;

        END LOOP;
    CLOSE cursorCP;
    DBMS_OUTPUT.PUT_LINE('');

    -- Comprobaci�n de violaci�n de clave primaria.
    IF numPKrep + numPKnull > 0 THEN
        RAISE PK_REP;    
    ELSE
        DBMS_OUTPUT.PUT_LINE (
            'No hay ninguna clave primaria repetida.'
        );
    END IF;
    DBMS_OUTPUT.PUT_LINE('');

EXCEPTION
    WHEN PK_REP THEN
        IF numPKrep > 0 THEN
            DBMS_OUTPUT.PUT_LINE (
                'Hay ' || numPKrep || ' clave(s) primaria(s) repetida(s).'
            );
        END IF;
        IF numPKnull > 0 THEN
            DBMS_OUTPUT.PUT_LINE (
                'Hay ' || numPKnull || ' clave(s) primaria(s) nula(s).'
            );
        END IF;

END;

EXECUTE comprobar_PK;

-- Salida: 
--
--Procedure COMPROBAR_PK compilado
--
--Se comprueba la existencia de claves primarias repetidas en la tabla "C�digos postales I":
--
--08050, Zaragoza, Zaragoza;
--08050, Parets, Barcelona;
--
--, Arganda, Sevilla;
--
--Hay 1 clave(s) primaria(s) repetida(s).
--Hay 1 clave(s) primaria(s) nula(s).
--
--Procedimiento PL/SQL terminado correctamente.