DROP TABLE IF EXISTS fibonacci CASCADE;
CREATE TABLE fibonacci(
	n INTEGER,
	fib_n BIGINT
);

CREATE OR REPLACE FUNCTION fib(n INTEGER)
RETURNS SETOF fibonacci AS $$
	DECLARE
		ans fibonacci%ROWTYPE;
		x BIGINT;
		y BIGINT;
	
	BEGIN
		x := 0;
		y := 1;

		FOR i IN 1..n LOOP
			ans.n := i;
			ans.fib_n := y;
			RETURN NEXT ans;
			y := y + x;
			x := y - x;
		END LOOP;

	RETURN;

	END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------


SELECT * FROM fib(5);

SELECT * FROM fib(2);

SELECT * FROM fib(91);

--Overflow
--SELECT * FROM fib(92);