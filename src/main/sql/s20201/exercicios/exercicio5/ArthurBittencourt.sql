DROP FUNCTION IF EXISTS det(m float[][]) CASCADE;

CREATE FUNCTION det(m float[][]) RETURNS float AS $$

DECLARE

deter float;

columnc integer;
linec integer;

columni integer;
linei integer;

mi float[][];

BEGIN
deter := 0;

linec := cardinality(m)/cardinality(m[1:1]);
columnc := cardinality (m[1:1]);

IF linec <> columnc THEN
RAISE EXCEPTION 'Matriz fornecida é não quadrada';
END IF;

linei := 1;
columni := 1;

IF linec = 2 AND columnc = 2 THEN
deter := m[1][1]*m[2][2] - m[2][1]*m[1][2];
RAISE NOTICE 'returning %', deter;
return deter;
END IF;

WHILE columni < columnc +1 LOOP
mi := exlincol(m, columni, 1);
RAISE NOTICE '%', mi;
deter := deter + m[columni][1]*det(mi)*(-1^(columni+1));
columni := columni +1;
END LOOP;

RETURN deter;

END;

$$ LANGUAGE plpgsql;

DROP TABLE IF EXISTS testex CASCADE;

CREATE TABLE testex(
testarray float[][]
);

INSERT INTO testex VALUES (
ARRAY [[11, 21, 31],[12, 22, 32],[13, 23, 33] ]
);

SELECT det(testarray) FROM testex;