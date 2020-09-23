/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 23 de set. de 2020
 * Task: Fibonacci
 */

CREATE OR REPLACE FUNCTION fibonacci (n int)
    RETURNS int[][]
    AS $$
    DECLARE       
        fib int[][];
        linha_append int[];
        aux1 int = 1;
        aux2 int = 0;
        
    BEGIN

        FOR i IN 1..n LOOP
            linha_append[1] := i;
            linha_append[2] := aux1;
            fib = array_cat(fib, ARRAY[linha_append]); 
            aux1 := aux1 + aux2;
            aux2 := aux1 - aux2;
        END LOOP;
        
        RETURN fib;
    END;
$$
LANGUAGE PLPGSQL;

--{{1,1},{2,1},{3,2},{4,3},{5,5},{6,8},{7,13},{8,21},{9,34},{10,55}}
SELECT fibonacci(10)

