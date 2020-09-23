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

drop function if exists determinante(m float[][]) cascade;

create table matriz(
    valores float[][]
);

insert into matriz values ('{{4,2,3},{1,5,2},{7,2,4}}');

/*select * from matriz;*/

create function determinante(m float[][]) returns int as $$
    declare
        qtdLinhas int;
        qtdColunas int;
        soma int;
        subMatriz float[][];
    begin
        select array_length(m, 1) into qtdLinhas;
        select array_length(m, 2) into qtdColunas;
        
        if qtdColunas != qtdLinhas then
            raise exception 'Matriz não é quadrada!';
        end if;

        if qtdLinhas = 1 then
            return m[1][1];
        end if;
        
        soma := 0;
        for j in 1..qtdColunas loop
            select excluiLinhaColuna(m, 1, j ) into subMatriz;
            soma := soma + ((-1)^(1+j)) * m[1][j] * determinante(subMatriz);
        end loop;
        
        return soma;
    end;
$$
language plpgsql;

select determinante(matriz.valores ) from matriz;
