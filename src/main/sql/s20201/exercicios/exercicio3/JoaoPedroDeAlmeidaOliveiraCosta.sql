drop function if exists M1xM2 cascade;
drop table if exists Table1 cascade;
drop table if exists Table2 cascade;


create table Table1(
    colunaM1 float[][]
);

create table Table2(
    colunaM2 float[][]
);

INSERT INTO Table1 VALUES (ARRAY[[1,1,1],[1,1,1],[1,1,1]]);

INSERT INTO Table1 VALUES (ARRAY[[1, 2, 1],[1, 1, 1],[1, 1, 1]]);

INSERT INTO Table2 VALUES (ARRAY[[1,2,3]]);

--INSERT INTO Table2 VALUES (ARRAY[[1,2]]);
--comentar para retirar caso de falha

create or replace function M1xM2(M1 float[][], M2 float[][])
returns float[][] as $$
declare
    M1L integer;
    M1C integer;
    M2L integer;
    M2C integer;
    somador integer;
    M3 float[][];
    Aux float[];
begin
    M1L := array_length(M1, 2);
    M1C := array_length(M1, 1);
    M2L := array_length(M2, 2);
    M2C := array_length(M2, 1);

    RAISE NOTICE 'Linhas m1 -> %, Colunas m2 -> %. Linhas m1 ->%, Colunas m2 -> %', M1L , M1C, M2L ,M2C;

    if M1C <> M2L then raise exception 'Matrizes incompatíveis';
    end if;

    M3 := array_fill(0, array[M1L,M2C]);

    for linha in 1..M1L loop
        for coluna in 1..M2C loop
            somador = 0;
            RAISE NOTICE 'Restart loop';
            for k in 1..M1C loop
                somador := somador + M1[k][linha] * M2[coluna][k];
                RAISE NOTICE 'Quantity here is %, %', M1[k][linha], M2[coluna][k];
            end loop;
        M3[linha][coluna] = somador;
        end loop;
    end loop;

    return M3;
END
$$ LANGUAGE plpgsql;



select M1xM2(table1.colunam1, table2.colunam2) from table1, table2;