/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  matheus
 * Created: 21/09/2020
 */

drop table if exists matriz cascade;

create table matriz (
    val float[][]
);

insert into matriz values (array[[1,2,3],[4,5,6],[7,8,9]]);

create or replace function detMat (m float[][]) returns float as $$
    declare 
        m_i integer;
        m_j integer;
        aux float[][];
        resp float default 1;
        
    begin
        select array_length(m, 2) into m_i;
        select array_length(m, 1) into m_j;
        select array_fill(0, array[m_i-1, m_j-1]) into aux;
            
        if (m_i!=m_j) then 
            raise exception 'Não é possível calcular o determinante dessa matriz.';
        end if;
        
        for i in 1..m_i loop
            for j in 1..m_j loop
                if (m_i=m_j) then resp = resp * m[i][j];
                end if;
            end loop;
        end loop;
        return resp;
    end;
        
$$
language plpgsql;

select detMat(matriz.val) from matriz;