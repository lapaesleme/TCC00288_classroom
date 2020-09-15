/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  Gabriel
 * Created: 14 de set. de 2020
 */

drop table if exists pessoa  cascade;
create table pessoa(
nome varchar,
endereco decimal(4,2)
);
insert into pessoa values ('Gabriel Araujo','2');
insert into pessoa values ('Gabriel','1.2');

select * from pessoa;