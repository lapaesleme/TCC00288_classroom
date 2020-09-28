/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  mathe
 * Created: 23/09/2020
 */

drop table if exists matriz;

create table matriz (
    val float[][]
);

insert into matriz values (array[[1,2,3],[4,5,6],[7,8,9]]);


create or replace function tranporMat (m float[][]) returns float[][] as $$
    declare 
        m_i integer;
        m_j integer;
        m_result float[][];

    begin
        select array_length(m, 2) into m_i;
        select array_length(m, 1) into m_j;
        select array_fill(0, array[m_j,m_i]) into m_result;

        for i in 1..m_i loop
            for j in 1..m_j loop
                m_result := m[j][i];
            end loop;
        end loop;
        return m_result;
    end
$$ 
language plpgsql;


select transporMat (matriz.val) from matriz;