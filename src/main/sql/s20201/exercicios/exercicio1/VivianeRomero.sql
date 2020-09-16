drop table if exists pessoa  cascade;

create table pessoa(
nome varchar,
endereco varchar
);

insert into pessoa values ('Viviane Romero','end');
insert into pessoa values ('Viviane','end2');

select * from pessoa;

