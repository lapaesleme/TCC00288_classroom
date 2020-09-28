DROP TABLE if exists Fibonacci cascade;

CREATE TABLE Fibonacci(
    i integer,
    num integer
);

CREATE OR REPLACE FUNCTION fibonacci(n integer) RETURNS SETOF Fibonacci AS $$
DECLARE
    fib_ant_ant integer;
    fib_ant integer;
    aux integer;
BEGIN
    fib_ant_ant := 1;
    fib_ant := 1;

    FOR x in 1..n LOOP
        IF x = 1 or x = 2 THEN
            RETURN NEXT (x, 1);
        ELSE
            aux := fib_ant_ant + fib_ant;
            fib_ant_ant := fib_ant;
            fib_ant := aux;

            RETURN NEXT (x, aux);
        END IF;
    END LOOP;
END
$$ LANGUAGE plpgsql;

SELECT * FROM fibonacci(15);