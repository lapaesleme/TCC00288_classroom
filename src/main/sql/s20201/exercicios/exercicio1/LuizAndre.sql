drop table if exists pessoa  cascade;
create table pessoa(
nome varchar,
endereco varchar
);
insert into pessoa values ('Lucas Amaral','end');
insert into pessoa values ('Luiz','end2');



select * from pessoa;