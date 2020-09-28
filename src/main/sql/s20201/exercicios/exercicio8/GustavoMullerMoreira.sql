drop function if exists fibonacci(matriz float[][]) cascade;
drop table if exists fiboNumbers cascade;

CREATE TABLE fiboNumbers (
    i integer,
    numero integer
);

CREATE or REPLACE FUNCTION fibonacci(n integer) RETURNS SETOF fiboNumbers AS $$
DECLARE
    f1 integer := 1;
    f2 integer := 1;
    atual integer;
BEGIN

    IF n = 1 THEN
        RETURN NEXT (1, 1);
        RETURN;
    END IF;

    RETURN NEXT (1, 1);
    RETURN NEXT (2, 1);

    FOR i IN 3..n LOOP
        atual = f1 + f2;
        RETURN NEXT (i, atual);
        
        f1 = f2;
        f2 = atual;
    END LOOP;

END;
$$ LANGUAGE plpgsql;


select * from fibonacci(12);