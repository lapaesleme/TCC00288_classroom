DROP TABLE IF EXISTS Mat1 CASCADE;
DROP TABLE IF EXISTS Mat2 CASCADE;
DROP TABLE IF EXISTS MatError CASCADE;

CREATE TABLE Mat1
(
elem float[][]
);

CREATE TABLE Mat2
(
elem float[][]
);

CREATE TABLE MatError
(
elem float[][]
);


INSERT INTO Mat1 (elem) VALUES (ARRAY [[1,2],[4,5],[9,10]]);
INSERT INTO Mat2 (elem) VALUES (ARRAY[[2,3,4],[3,4,5]]); 
INSERT INTO MatError (elem) VALUES (ARRAY[[2,3,4]]);

DROP FUNCTION IF EXISTS MultiplicaMat(Mat1 float[][], Mat2 float[][]) CASCADE;

CREATE FUNCTION MultiplicaMat(m1 float[][], m2 float[][]) RETURNS float[][] AS $$
DECLARE
    numLM1 integer;
    numCM1 integer;
    numLM2 integer;
    numCM2 integer;
    matRes float[][];
BEGIN
    SELECT array_length(m1, 1) INTO numLM1;
    SELECT array_length(m1, 2) INTO numCM1;
    SELECT array_length(m2, 1) INTO numLM2;
    SELECT array_length(m2, 2) INTO numCM2;
    SELECT array_fill(0, ARRAY[numLM1,numCM2]) INTO matRes;

    IF numCM1 != numLM2 THEN
        RAISE EXCEPTION 'multiplicação invalida';
    END IF;

    FOR i IN 1..numLM1 LOOP
        FOR j IN 1..numCM2 LOOP
            FOR k IN 1..numCM1 LOOP
                matRes[i][j] := matRes[i][j] + m1[i][k] * m2[k][j]; 
            END LOOP;
        END LOOP;
    END LOOP;
    RETURN matRes;
END;
$$ 
LANGUAGE PLPGSQL;


SELECT MultiplicaMat(Mat1.elem, Mat2.elem) 
FROM Mat1, Mat2;

SELECT MultiplicaMat(Mat1.elem, MatError.elem)
FROM Mat1, MatError;