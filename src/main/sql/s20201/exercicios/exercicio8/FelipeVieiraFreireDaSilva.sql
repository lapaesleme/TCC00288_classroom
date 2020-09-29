CREATE OR REPLACE FUNCTION fibo (n integer)
    RETURNS table(i integer, numero integer)
    AS $$
    DECLARE

        pos integer;
        soma integer;
        primeiro integer = 1;
        segundo integer = 1;

    BEGIN
        IF n = 1 THEN

            RETURN QUERY SELECT 1, 1;

        ELSIF n = 2 THEN

            RETURN QUERY SELECT 1, 1;
            RETURN QUERY SELECT 2, 1;

        ELSE

            RETURN QUERY SELECT 1, 1;
            RETURN QUERY SELECT 2, 1;
            
            FOR i IN 3..n LOOP

                pos = i;
                soma = primeiro + segundo;
                segundo = primeiro;
                primeiro = soma;
                RETURN QUERY SELECT pos, soma;

            END LOOP;
        END IF;
        RETURN;
    END;
$$
    LANGUAGE PLPGSQL;

SELECT * FROM fibo(10);