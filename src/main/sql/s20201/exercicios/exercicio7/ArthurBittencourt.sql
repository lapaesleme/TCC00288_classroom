DROP FUNCTION IF EXISTS tmat(m float [][]) CASCADE;

CREATE FUNCTION tmat(m float[][]) RETURNS float[][] AS $$

    DECLARE

        linec integer;
        columnc integer;

        linei integer;
        columni integer;

        i float;
        rline float[];
        r float[][];

    BEGIN

        columnc := cardinality(m[1:1]);
        linec := cardinality(m)/columnc;

        columni := 1;
        linei := 1;

        FOREACH i IN ARRAY $1 LOOP

            rline := array_append(rline, m[linei][columni]);
            linei := linei +1;

            IF linei = linec+1 THEN
                r := array_cat(r, rline);
                rline := ARRAY[]::float[];
                linei := 1;
                columni := columni +1;
            END IF;

        END LOOP;

        RETURN r;

    END;

$$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS testable CASCADE;

CREATE TABLE testable(
testarray float[][]
);

INSERT INTO testable VALUES(
ARRAY [[11,12,13], [21,22,23], [31,32,33] ]
);

SELECT tmat(testarray) FROM testable;