
/**
 * Author:  Philippe Geraldeli
 * Created: 23/09/2020

Escreva uma função PL/pgSQL que retorne uma relação com esquema {i,numero}
contendo os � primeiros números da sequência de Fibonacci, onde � é informado como
parâmetro. Lembre-se que �! = 1, �" = 1 e �# = �#$! + �#$".
 */



DROP FUNCTION IF EXISTS fib(n integer);
DROP FUNCTION IF EXISTS fib_rel(n integer);

CREATE OR REPLACE FUNCTION fib (n int) RETURNS integer AS $$
    BEGIN
        IF n < 2 THEN
            RETURN n;
        END IF;
        RETURN fib(n - 2) + fib(n - 1);
    END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION fib_rel (n integer) RETURNS TABLE(pos integer, valor integer) AS $$
    DECLARE
        result integer[][];
        aux integer[];
    BEGIN
        result := array_fill(0, ARRAY[n, 2]);
		RAISE NOTICE 'result: %', result;
        FOR i IN 1..n LOOP
            RETURN QUERY SELECT i AS pos, fib(i) AS valor;
        END LOOP;
    END;
$$ LANGUAGE plpgsql;


SELECT * FROM fib_rel(6);



