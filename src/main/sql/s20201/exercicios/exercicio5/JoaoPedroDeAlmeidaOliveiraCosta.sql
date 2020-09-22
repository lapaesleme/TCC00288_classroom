drop function if exists determinante cascade;
drop table if exists Table1 cascade;
drop table if exists Table2 cascade;


create table Table1(
    colunaM1 float[][]
);

create table Table2(
    colunaM1 float[][]
);


INSERT INTO Table1 VALUES (ARRAY[[1,2],[4,5]]);
INSERT INTO Table1 VALUES (ARRAY[[1]]);
INSERT INTO Table1 VALUES (ARRAY[[-2, 0, 3,1],[3, -1, -4, 0],[1,2,5,-2],[7,1,1,-1]]);
INSERT INTO Table1 VALUES (ARRAY[[1,0,0,0,0],[2,4,1,-6,2],[3,0,0,6,0],[-3,0,1,1,1],[1,0,1,3,1]]);
INSERT INTO Table1 VALUES (ARRAY[[0,-1,0,1,0],[2,0,-3,2,1],[1,2,0,3,0],[1,0,0,0,0],[-3,0,0,0,2]]);



INSERT INTO Table2 VALUES (ARRAY[[1],[4],[7]]);
--comentar para retirar caso de erro

create or replace function determinante(Matriz float[][]) returns float as $$
DECLARE
    det integer;
    Maux float[][];
    Aux float[];
    ML integer;
    MC integer;
begin
    ML := array_length(Matriz, 2);
    MC := array_length(Matriz, 1);
    det := 0;

    if ML <> MC or ML < 0 or MC < 0 then raise exception 'a matriz não é quadrada';
    end if;
    
    
    if ML = 0 then return 0;
    
    elsif ML = 1 then
       return Matriz[1][1];
       
    elsif ML = 2 then
       return (Matriz[1][1]*Matriz[2][2] - Matriz[1][2]*Matriz[2][1]);
       
    else 
        for j in 1..MC loop
            RAISE NOTICE 'Coluna %', j;
            Maux := '{}';
            for coluna in 1..MC loop
                if coluna <> j then
       
                    Aux = '{}';
                    for linha in 2..ML loop
                        Aux := array_append(Aux, Matriz[coluna][linha]);
                    end loop;
                    Maux = array_cat(Maux,array[Aux]);
                end if;
            end loop;
            det = det + Matriz[j][1]*((-1)^(j+1)) * determinante(Maux);
        end loop;
        return det;
    end if;
           
    
END
$$ LANGUAGE plpgsql;


Select determinante(Table1.colunam1) from Table1;