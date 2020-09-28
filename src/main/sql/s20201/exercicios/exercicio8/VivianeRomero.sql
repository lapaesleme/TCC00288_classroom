DROP FUNCTION fibonacci IF EXISTS;

CREATE OR REPLACE FUNCTION fibonacci(n integer) RETURNS TABLE(i integer, numero integer) AS $$
DECLARE
    numero integer;
    anterior1 integer;
    anterior2 integer;
BEGIN
    anterior1 := 1;
    anterior2 := 0;
    FOR i IN 1..n LOOP
        IF i = 1 THEN
            RETURN query SELECT i, anterior1;
        ELSE
            numero := anterior1 + anterior2;
            anterior2 := anterior1;
            anterior1 := numero;
            RETURN query SELECT i, numero;
        END IF;
    END LOOP;
    RETURN;
END
$$ LANGUAGE plpgsql;

SELECT * FROM fibonacci(7);