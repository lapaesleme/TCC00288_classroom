DROP FUNCTION IF EXISTS exlincol(m float[][], i integer, j integer) cascade;

CREATE FUNCTION exlincol(m float[][], i integer, j integer) RETURNS float [][] AS $$

DECLARE

u integer;
v integer;
r float[][];

linec integer;
columnc integer;

columni integer;
linei integer;

columnu integer;
lineu integer;

BEGIN

columni := 1;
linei := 1;

columnu :=1;
lineu :=1;

linec := cardinality(m)/cardinality(m[1:1]);
columnc := cardinality(m[1:1]);

r := m[1: linec -1][1:columnc -1];
--RAISE NOTICE 'r is %', r;

FOREACH u IN ARRAY $1
LOOP

IF columni <> j THEN 
IF linei <> i THEN
r[lineu][columnu] := u;

columnu := columnu +1;
IF columnu = columnc THEN
columnu := 1;
lineu := lineu +1;
END IF;
--RAISE NOTICE 'wrote % into r[%][%]', u, columnu, lineu;

END IF;
END IF;

columni := columni +1;

IF columni = columnc +1 THEN
columni := 1;
linei := linei +1;
END IF;

END LOOP;


RETURN r;

END;

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