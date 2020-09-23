
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

CREATE FUNCTION fib_rel (n integer) RETURNS float[][] AS $$
    DECLARE
        result integer[][];
        aux integer[];
    BEGIN
        result := array_fill(0, ARRAY[n, 2]);
		RAISE NOTICE 'result: %', result;
        FOR i IN 1..n LOOP
            result[i][1] := i;
            result[i][2] := fib(i);
        END LOOP;
		
		RETURN result;
    END;
$$ LANGUAGE plpgsql;


SELECT fib_rel(6);  -- {{1,1},{2,1},{3,2},{4,3},{5,5},{6,8}}



