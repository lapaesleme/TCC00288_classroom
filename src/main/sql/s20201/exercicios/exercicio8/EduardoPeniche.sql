
DROP FUNCTION IF EXISTS fibo(n integer);
CREATE OR REPLACE FUNCTION fibo(n integer) RETURNS table(i integer, numero integer)
    AS $$
    DECLARE
        pos integer;
        valor integer;
        um_atras integer = 1;
        dois_atras integer = 1;
    BEGIN
        IF n = 1 THEN
            RETURN QUERY SELECT 1,um_atras;
        ELSIF n = 2 THEN
            RETURN QUERY SELECT 1,um_atras;
            RETURN QUERY SELECT 2,um_atras;
        ELSE
            RETURN QUERY SELECT 1,um_atras;
            RETURN QUERY SELECT 2,um_atras;
            FOR j IN 3.. n LOOP
                pos = j;
                valor = um_atras + dois_atras;
                dois_atras = um_atras;
                um_atras = valor;
                RETURN QUERY SELECT pos,valor;
            END LOOP;
        END IF;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM fibo(5);
