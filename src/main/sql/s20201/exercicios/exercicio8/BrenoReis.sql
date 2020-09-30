DROP FUNCTION IF EXISTS calculateFibonacci(n integer);
CREATE OR REPLACE FUNCTION calculateFibonacci(n integer)
    RETURNS TABLE(i integer, fib integer) AS $$
    DECLARE
        fibArray integer[] := ARRAY[1,1];
    BEGIN
        IF n < 1 THEN
            RETURN;
         END IF;
        FOR i IN 1..n LOOP
            IF i = 1 THEN
                RETURN QUERY SELECT i, 1;
            ELSEIF i = 2 THEN
                RETURN QUERY SELECT i, 1;
            ELSE
                fibArray := array_append(fibArray, fibArray[i-2] + fibArray[i-1]);
                RETURN QUERY SELECT i, fibArray[i];
            END IF;
        END LOOP;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM calculateFibonacci(0);
