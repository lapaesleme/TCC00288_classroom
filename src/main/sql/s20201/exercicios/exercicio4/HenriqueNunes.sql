DROP FUNCTION IF EXISTS excluir_linha;
CREATE FUNCTION excluir_linha(i integer[],m integer[][]) 
RETURNS integer[][]
AS $$
DECLARE
    ret integer[][];
    mNumLines integer;
    mNumCols integer;
    x integer[];
BEGIN
    FOREACH x slice 1 in ARRAY m LOOP
        IF i != x THEN
            --RAISE NOTICE '>>> EH DIFERENTE % = %<<<',i,x;
            ret = array_cat(ret,ARRAY[x]);
        END IF;
    END LOOP;
    --RAISE NOTICE 'retornando excluir_linha';
  RETURN ret;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS excluir_coluna;
CREATE FUNCTION excluir_coluna(j integer[],m integer[][]) 
RETURNS integer[][]
AS $$
    DECLARE
        ret integer[][];
        mNumLines integer;
        mNumCols integer;
        x integer[];
        n integer;
        line integer[];
        test integer[];
        counter integer;
    BEGIN
        SELECT array_length(m, 1) INTO mNumCols;
        SELECT array_length(m, 2) INTO mNumLines;
        --SELECT array_fill(0, ARRAY[mNumCols, mNumLines-1]) INTO ret;
        counter = 0;
        FOREACH x slice 1 in ARRAY m LOOP
            FOR n IN 1..mNumCols LOOP
                IF NOT ARRAY[x[n] ] <@ ARRAY[j] THEN
                    line = array_append(line,x[n]);
                    --RAISE NOTICE 'NAO ESTA CONTIDO % - % - %',x,x[n],j;
                ELSE 
                    counter = counter + 1; 
                    --RAISE NOTICE 'ESTA CONTIDO % - % - % - counter %',x,x[n],j,counter;
                END IF;

            END LOOP;
            raise notice 'teste % - %',ret,line;
            ret = array_cat(ret,array[line]);
            line = test;
                IF counter =  mNumLines THEN
                    raise notice 'RETORNANDO: % ',ret;
                    RETURN ret;
                END IF;
        END LOOP;
      RETURN ret;
    END;
$$ LANGUAGE plpgsql;

--raise notice 'Apagando uma linha:';
select excluir_linha(ARRAY[ 1,2,3 ],ARRAY[ [1,2,3],[4,5,6],[7,8,9] ] ) as a;

--raise notice 'Apagando uma Coluna:';
select excluir_coluna(ARRAY[ 2,5,8 ],ARRAY[ [1,2,3],[4,5,6],[7,8,9] ] ) as a;


--raise notice 'Fazendo tudo de uma vez:'; -- Não funcionando.
--select excluir_coluna(ARRAY[ 5,8 ],select excluir_linha(ARRAY[ 1,2,3 ],ARRAY[ [1,2,3],[4,5,6],[7,8,9] ] ) )




