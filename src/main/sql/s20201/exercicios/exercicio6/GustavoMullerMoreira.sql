drop function opMatrix(A float[][], m integer, n integer, c1 integer, c2 integer) cascade;

CREATE or REPLACE FUNCTION opMatrix(A float[][], m integer, n integer, c1 integer, c2 integer) RETURNS float[][] AS $$
DECLARE
BEGIN
    
    FOR j IN 1..array_length(A,2) LOOP
        A[m][j] = c1 * A[m][j] + c2 * A[n][j];
    END LOOP;

    RETURN A;
END;
$$ LANGUAGE plpgsql;


select opMatrix('{{3,5,5},{5,5,5},{6,4,1},{7,6,5}}', 2, 1, 1, 2);