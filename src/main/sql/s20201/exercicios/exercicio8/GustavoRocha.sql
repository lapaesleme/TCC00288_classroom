DROP FUNCTION IF EXISTS Fibonacci(n integer)CASCADE;

CREATE OR REPLACE FUNCTION Fibonacci(n integer) RETURNS TABLE(i integer, numero integer) AS $$
DECLARE
    fibAtual integer := 1;
    fibAnterior integer := 1;
BEGIN
    FOR j in 1..n LOOP
        IF j = 1 THEN
            RETURN QUERY SELECT j, 1;
        ELSIF j = 2 THEN
            RETURN QUERY SELECT j, 1;
        ELSE
            fibAtual =  fibAtual + fibAnterior;
            fibAnterior = fibAtual - fibAnterior;
            RETURN QUERY SELECT j, fibAtual;
        END IF;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM Fibonacci(10);