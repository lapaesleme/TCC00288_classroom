DROP TABLE IF EXISTS fibonacci CASCADE;

CREATE TABLE fibonacci(i integer, numero integer);

DROP FUNCTION IF EXISTS fib(n integer) CASCADE;

CREATE FUNCTION fib(n integer) RETURNS SETOF fibonacci AS $$

DECLARE

c integer;
fb integer;
fn integer;

BEGIN
c := 0;
fb := 0;
fn := 1;

IF n = 0 THEN
RETURN NEXT(0, fb);
END IF;
IF n = 1 THEN 
RETURN NEXT(1, fn);
END IF;

WHILE c < n LOOP


RETURN NEXT(c, fb);
fn := fb + fn;
fb := fn - fb;
c := c+1;

END LOOP;

END;

$$ LANGUAGE plpgsql;


DROP TABLE IF EXISTS testarosa CASCADE;

CREATE TABLE testarosa(
thevalue integer
);

INSERT INTO testarosa VALUES(
1
);

SELECT * FROM fib(5);