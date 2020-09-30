drop function if exists atualizaAdicional cascade;
drop table if exists empregado cascade;
drop table if exists dependente cascade;


CREATE TABLE empregado (
empregado_id integer NOT NULL,
nome character varying NOT NULL,
salario real NOT NULL,
adicional_dep real NOT NULL,
CONSTRAINT empregado_pk PRIMARY KEY
(empregado_id)
);


CREATE TABLE dependente (
empregado_id integer NOT NULL,
seq smallint NOT NULL,
nome character varying NOT NULL,
CONSTRAINT dependente_pk PRIMARY KEY
(empregado_id, seq),
CONSTRAINT empregado_fk FOREIGN KEY
(empregado_id) REFERENCES empregado
(empregado_id)
);


INSERT INTO empregado values
    (1, 'Joao', 1000, 1),
    (2, 'Pedro', 2000, 1),
    (3, 'Carlos', 3000, 1),
    (4, 'Thiago', 3000, 1);



INSERT INTO dependente values
    (1, 1, 'Joao'),
    (1, 2, 'Pedro'),
    (1, 3, 'Carlos'),
    (2, 1, 'Joao'),
    (2, 2, 'Pedro'),
    (3, 1, 'Carlos');




create or replace function atualizaAdicional() RETURNS void as $$
declare
    empregadoID integer;
    numeroDependentes integer;
    empregadoRecord record;
begin
   empregadoID = -1;
   for empregadoRecord in select * from empregado loop
        empregadoID = empregadoRecord.empregado_id;
        for numeroDependentes in select Count(*) from dependente where dependente.empregado_id = empregadoID loop
            update empregado set adicional_dep = (1 + numeroDependentes*0.05) where empregado_id = empregadoID;
        end loop;
   end loop;
END
$$ LANGUAGE plpgsql;




select empregado.salario * empregado.adicional_dep from empregado;

select atualizaAdicional();

select empregado.salario * empregado.adicional_dep from empregado;