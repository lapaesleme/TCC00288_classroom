/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 23 de set. de 2020
 */

drop table if exists matriz cascade;
drop table if exists matriz1 cascade;
drop table if exists matriz2 cascade;

drop function if exists matrizTransposta(m float[][]) cascade;

create table matriz(
    valores float[][]
);

create table matriz1(
    valores float[][]
);

create table matriz2(
    valores float[][]
);

insert into matriz values ('{{4,2,3},{1,5,2},{7,2,4}}');
insert into matriz1 values ('{{1,7,8},{5,3,2}}');
insert into matriz2 values ('{{1,5},{7,3},{8,2}}');

/*select * from matriz;*/

create function matrizTransposta(m float[][]) returns float[][] as $$
declare
    qtdLinhas int;
    qtdColunas int;
    vetor float[];
    aux float[];
    resultado float[][];
begin
    select array_length(m, 1) into qtdLinhas;
    select array_length(m, 2) into qtdColunas;

    for i in 1..qtdColunas loop
        for j in 1..qtdLinhas loop
            /* adiciona a coluna no vetor */
            vetor := array_append(vetor, m[j][i]);
        end loop;
        raise notice 'vetor coluna: %', vetor;
        resultado := array_cat(resultado, array[vetor]);
        /* limpa o vetor para o próximo loop */
        vetor := aux;
    end loop;
    
    return resultado;

end
$$
language plpgsql;

select matrizTransposta(matriz.valores) from matriz;
select matrizTransposta(matriz1.valores) from matriz1;
select matrizTransposta(matriz2.valores) from matriz2;