drop table if exists pessoa cascade;

create table pessoa(
name varchar,
endereco varchar
);

insert into pessoa values ('Arthur', 'rua dos bobos');


select * from pessoa;
