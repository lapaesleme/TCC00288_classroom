drop function if exists transposta(matriz float[][]) cascade;

CREATE or REPLACE FUNCTION transposta(matriz float[][]) RETURNS float[][] AS $$
DECLARE
    tmatriz float[][];
    auxArray float[];
BEGIN

    FOR coluna IN 1..array_length(matriz,2) LOOP

        auxArray = '{}';

        FOR linha IN 1..array_length(matriz,1) LOOP
            auxArray = array_append(auxArray, matriz[linha][coluna]);
        END LOOP;

        tmatriz = array_cat(tmatriz, array[auxArray]);
    END LOOP;

    RETURN tmatriz;
END;
$$ LANGUAGE plpgsql;


select transposta('{{3,5,5},{5,5,5},{6,4,1},{7,6,5}}');