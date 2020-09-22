drop function if exists DeleteLC cascade;
drop table if exists Table1 cascade;


create table Table1(
    colunaM1 float[][]
);


INSERT INTO Table1 VALUES (ARRAY[[1,2,3],[4,5,6],[7,8,9]]);
INSERT INTO Table1 VALUES (ARRAY[[1,2],[4,5],[7,8]]);
INSERT INTO Table1 VALUES (ARRAY[[1],[4],[7]]);
INSERT INTO Table1 VALUES (ARRAY[[1,2,3],[4,5,6]]);

INSERT INTO Table1 VALUES (ARRAY[[1,2,3]]);
--comentar para retirar caso de erro

create or replace function DeleteLC(i int, j int, M float[][])
returns float[][] as $$
declare
    ML integer;
    MC integer;
    M3 float[][];
    Aux float[];
begin
    ML := array_length(M, 2);
    MC := array_length(M, 1);
    M3 = '{}';

    RAISE NOTICE 'Remover linha -> % das % linhas, Remover coluna -> % das % linhas', i , ML, j ,MC;
    
    if ML<0 or MC<0 or ML<i or MC<j then raise exception 'impossível concluir essa operação';
    end if;
    
    for coluna in 1..MC loop
    --raise notice '% - %', coluna, j;
        if coluna <> j then
            Aux := '{}';
            --raise notice '%', Aux;
            for linha in 1..ML loop
                if linha <> i then
                    Aux := array_append(Aux, M[coluna][linha]);
                    --raise notice '%', Aux;
                end if;
            end loop;
            if array_length(Aux,1)>0 then
                M3 = array_cat(M3,array[Aux]);
            end if;
        end if;
    end loop;
    
    raise notice 'saida: %', M3;
    return M3;
END
$$ LANGUAGE plpgsql;



select DeleteLC(1 , 1 , table1.colunaM1) from table1;

select DeleteLC(1 , 2 , table1.colunaM1) from table1;
