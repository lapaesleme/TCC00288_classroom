
DROP FUNCTION IF EXISTS fibonacci() CASCADE;
 
CREATE OR REPLACE FUNCTION fibonacci(n integer)
    RETURNS table(i integer, numero integer)
    AS $$
    DECLARE
        umAntes integer default 1;
        doisAntes integer default 1;
        result integer default 1;
    BEGIN
        FOR i in 1..n LOOP
            IF i = 1 OR i = 2 THEN
                umAntes := 1;
                doisAntes := 1;
                result := 1;
                RETURN QUERY SELECT i, result;
            ELSE
                result := umAntes + doisAntes;
                doisAntes := umAntes;
                umAntes := result;
                RETURN QUERY SELECT i, result;
            END IF;         
        END LOOP;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;


SELECT * FROM fibonacci(10);

