DROP TABLE IF EXISTS TabelaFibonacci;

CREATE TABLE TabelaFibonacci (
    i integer,
    numero bigint
);

DROP FUNCTION IF EXISTS fibonacci (n integer);

CREATE OR REPLACE FUNCTION fibonacci (n integer)
    RETURNS TABLE (
        i integer,
        numero bigint
    )
    AS $$
DECLARE
    sequencia integer[];
BEGIN
    sequencia[0] := 0;
    sequencia[1] := 1;
    IF n < 0 THEN
        RAISE EXCEPTION 'Erro. n é inválido';
    END IF;
    INSERT INTO TabelaFibonacci (i, numero)
        VALUES (0, sequencia[0]);
    INSERT INTO TabelaFibonacci (i, numero)
        VALUES (1, sequencia[1]);
    FOR j IN 2..n LOOP
        sequencia[j] = sequencia[j - 1] + sequencia[j - 2];
        INSERT INTO TabelaFibonacci (i, numero)
            VALUES (j, sequencia[j]);
    END LOOP;
    RETURN QUERY SELECT * FROM TabelaFibonacci;
END;
$$
LANGUAGE PLPGSQL;

SELECT
    *
FROM
    fibonacci (30);

