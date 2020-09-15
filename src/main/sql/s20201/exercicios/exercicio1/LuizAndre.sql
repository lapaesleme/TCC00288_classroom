drop table if exists pessoa  cascade;
create table pessoa(
nome varchar,
endereco varchar
);
insert into pessoa values ('Gabriel Araujo','end');
insert into pessoa values ('Gabriel','end2');

select * from pessoa;