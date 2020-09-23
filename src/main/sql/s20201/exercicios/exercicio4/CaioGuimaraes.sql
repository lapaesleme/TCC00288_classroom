/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  kai_o
 * Created: 22 de set. de 2020
 */

drop table if exists matriz cascade;

drop function if exists excluiLinhaColuna(m float[][], i int, j int) cascade;

create table matriz(
    valores float[][]
);

insert into matriz values ('{{4,2,3},{1,5,2},{7,2,4}}');

select * from matriz;

create function excluiLinhaColuna(m float[][], i int, j int) returns float[][] as $$
declare
    qtdLinhas int;
    qtdColunas int;
    resultado float[][];
    vetor float[];
    aux float[];
begin
    select array_length(m, 1) into qtdLinhas;
    select array_length(m, 2) into qtdColunas;

    raise notice 'linhas: %', qtdLinhas;
    raise notice 'colunas: %', qtdColunas;

    /* adiociona no vetor os elementos que nao pertencerem a linha e coluna que devem ser removidas
        e depois adiciona este vetor a matriz resultado */
    for linha in 1..qtdLinhas loop
        if linha != i then
            for coluna in 1..qtdColunas loop
                if coluna != j then
                    vetor := array_append(vetor, m[linha][coluna]);
                    /*raise notice 'vetor: %', vetor;*/
                end if;
            end loop;
            resultado := array_cat(resultado, array[vetor]);
            /*raise notice 'matriz resultado: %', resultado;*/
            /* esvazia o vetor para o proximo loop */
            vetor := aux;
        end if;
    end loop;

    return resultado;
                
end
$$
language plpgsql;

select excluiLinhaColuna(matriz.valores, 1, 1) from matriz;