/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 22 de set. de 2020
 */

drop table if exists matriz1 cascade;
drop table if exists matriz2 cascade;
drop table if exists matriz3 cascade;

drop function if exists multiplicaMatriz(m1 float[][], m2 float[][]) cascade;

/* Tabelas das matrizes que serão multiplicadas */
create table matriz1(
    valores float[][]
);

create table matriz2(
    valores float[][]
);

/* Tabela de resultado da multiplicação */
create table matriz3(
    valores float[][]
);

/* Inicializando as matrizes */
/*insert into matriz1 values(array[[4,2,3], [1,5,2], [7,2,4] ]);
insert into matriz2  values(array[[2,5,1], [7,3,9], [6,8,2] ]);*/
insert into matriz1 values ('{{4,2,3},{1,5,2},{7,2,4}}');
insert into matriz2 values ('{{2,5,1},{7,3,9},{6,8,2}}');
insert into matriz3 values ('{{8,2,1},{1,3,4}}');

/* verificando inicialização */
select * from matriz1;
select * from matriz2;

/* Funçao para multiplicar matriz */
create function multiplicaMatriz(m1 float[][], m2 float[][]) returns float[][] as $$
declare
    linhas_m1 int;
    colunas_m1 int;
    linhas_m2 int;
    colunas_m2 int;
    resultado float[][];
begin
    select array_length(m1, 1) into linhas_m1;
    select array_length(m1, 2) into colunas_m1;
    select array_length(m2, 1) into linhas_m2;
    select array_length(m2, 2) into colunas_m2;

    raise notice 'linhas m1: %', linhas_m1;
    raise notice 'colunas m1: %', colunas_m1;
    raise notice 'linhas m2: %', linhas_m2;
    raise notice 'colunas m2: %', colunas_m2;

    if colunas_m1 != linhas_m2 then
        raise exception 'Multiplicação Inválida!';
    end if;

    /* preenche a matriz resultado com zero na dimensao correta */
    select array_fill(0, array[colunas_m1,linhas_m2]) into resultado;

    for i in 1..linhas_m1 loop
        for j in 1..colunas_m2 loop
            for k in 1..linhas_m2 loop
                resultado[i][j] := resultado[i][j] + m1[i][k] * m2[k][j];
            end loop;
        end loop;
    end loop;
    
    return resultado;
end;
$$
language plpgsql;

/*Multiplicação Válida*/
select multiplicaMatriz(matriz1.valores, matriz2.valores) from matriz1, matriz2;
/*Multiplicação Inválida*/
select multiplicaMatriz(matriz1.valores, matriz3.valores) from matriz1, matriz3;