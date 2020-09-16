/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  yagorezende
 * Created: Sep 14, 2020
 */
drop table if exists pessoa  cascade;
create table pessoa(
nome varchar,
endereco varchar
);
insert into pessoa values ('Yago Rezende','endereço de Yago');
insert into pessoa values ('Luiz André','endereço de Luiz André');

select * from pessoa;
