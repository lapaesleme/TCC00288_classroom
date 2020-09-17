/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  Gabriel
 * Created: 14 de set. de 2020
 */

drop table if exists Fornecedor cascade;
create table Fornecedor(
f varchar,
nome varchar,
stat int,
cidade varchar
);

insert into Fornecedor values ('S1','Smith','20','Londres');
insert into Fornecedor values ('S1','Smith','20','Londres');
insert into Fornecedor values ('S2','Jones','10','Paris');
insert into Fornecedor values ('S3','Blake','30','Paris');

drop table if exists Fornecedor1 cascade;
create table Fornecedor1(
f varchar,
nome varchar,
stat int,
cidade varchar
);

insert into Fornecedor1 values ('S1','Smith','20','Londres');
insert into Fornecedor1 values ('S4','Jones','10','Paris');

drop table if exists Pecas cascade;
create table Pecas(
p varchar,
nome varchar,
cor varchar,
peso int,
cidade varchar
);

insert into Pecas values ('P1','Porca','Verm','12','Londres');
insert into Pecas values ('P2','Trinco','Verde','17','Paris');
insert into Pecas values ('P3','Parafuso','Azul','17','Roma');
insert into Pecas values ('P4','Parafuso','Verm','14','Londres');

drop table if exists FP cascade;
create table FP(
f varchar,
p varchar,
qtd int
);

insert into FP values ('S1','P1','300');
insert into FP values ('S1','P2','200');
insert into FP values ('S1','P3','400');
insert into FP values ('S1','P4','200');
insert into FP values ('S2','P1','300');
insert into FP values ('S2','P2','400');
insert into FP values ('S3','P2','200');

drop table if exists PLondres cascade;
create table PLondres(
p varchar
);

insert into PLondres values ('P1');
insert into PLondres values ('P2');

/* Projeção
select distinct p from Fp;  */

Intersecção
select fornecedor.f from fornecedor,fornecedor1 where fornecedor.f = fornecedor1.f;

/* produto cartesiano
select * from fornecedor,pecas; */

/* renomeação
select p as codP, f as codF, qtd as quantidade from pecas; */

/* Join
select * from Fornecedor Join FP on Fornecedor.f = FP.f; */

/* Natural Join
select * from Fornecedor Natural Join Fp; */

/* SELECT * from fornecedor,fornecedor1;
 */

/* Select * from fornecedor union Select * from fornecedor1;

select f from fornecedor where f='S1'; */

/* select * from fornecedor EXCEPT select * from fornecedor1; */


/* SELECT distinct f from FP as a1 where not exists((select p from PLondres) EXCEPT (select a2.p from FP as a2 where a2.f = a1.f));

SELECT * from FP;
select f,count(p), AVG(qtd) from FP GROUP BY f;
SELECT * from FP;

Select f,p,qtd + 10
from FP; */