DROP FUNCTION IF EXISTS fibonacci;


CREATE OR REPLACE FUNCTION fibonacci(n int) RETURNS TABLE(i int, numero int) AS $$
DECLARE
    fibo int[];
BEGIN
    IF n = 0 THEN
        RAISE EXCEPTION 'n deve ser maior que 0!';
    END IF;
    FOR i IN 1..n LOOP        
        IF i < 3 THEN
            fibo := array_append(fibo, 1);
            RETURN QUERY SELECT i,fibo[i];
        ELSE
            fibo := array_append(fibo, fibo[i-1]+fibo[i-2]);
            RETURN QUERY SELECT i,fibo[i];
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fibonacci(8);
SELECT * FROM fibonacci(0);
