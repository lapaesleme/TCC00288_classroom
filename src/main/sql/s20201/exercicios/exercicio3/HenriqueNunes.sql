drop table if exists float1 cascade;
create table float1 ( 
    content float[][]
);
insert into float1  (content) values(ARRAY[[1, 2, 3],[4, 5, 6],[7, 8, 9] ]);

drop table if exists float2 cascade;
create table float2 ( 
    content float[][]
);
insert into float2  (content) values(ARRAY[[1],[2],[3] ]);

drop function if exists multiplyMatrix;
CREATE OR REPLACE FUNCTION multiplyMatrix(m1 float[][],m2 float[][]) 
RETURNS float[][]
AS $$
DECLARE
    m1NumCols integer;
    m2NumCols integer;
    m1NumLines integer;
    m2NumLines integer;
    m3 float[][];
BEGIN
    SELECT array_length(m1, 1) INTO m1NumCols;
    SELECT array_length(m2, 1) INTO m2NumCols;
    SELECT array_length(m1, 2) INTO m1NumLines;
    SELECT array_length(m2, 2) INTO m2NumLines;

    SELECT array_fill(0, ARRAY[m1NumLines, m2NumCols]) INTO m3;

    IF m1NumLines != m2NumCols THEN
        RAISE EXCEPTION 'Numero de colunas de m1 eh diferente do numero de linhas de m2';
    END IF;

    FOR v IN 1..m1NumCols LOOP -- x[][...]
        FOR i IN 1..m2NumLines LOOP -- x[][...]
            FOR j IN 1..m2NumCols LOOP -- x[...][]
                m3[v][i] =  m3[v][i] + m1[v][j]*m2[j][i];
            END LOOP;
        END LOOP;
    END LOOP;

  RETURN m3;
END;
$$ LANGUAGE plpgsql;

--  Correto
select multiplyMatrix(float1.content,float2.content) from float1,float2 ;

-- Lança exceção
select multiplyMatrix(float2.content,float1.content) from float1,float2 ;

