/**
 * Author:  Victor Hugo Corpas dos S. Guaraná
 * Created: 23 de set. de 2020
 * Task: Mediana
 */

drop table if exists pais  cascade;
drop table if exists estado  cascade;

create table pais(
codigo int,
nome varchar,
primary key (codigo)
);

create table estado(
nome varchar,
pais int,
area int,
CONSTRAINT fk_pais FOREIGN KEY(pais) 
    REFERENCES pais(codigo)
);

insert into pais values (1,'Brasil');
insert into pais values (2,'Argentina');
insert into pais values (3,'Canada');
insert into pais values (4,'Dinamarca');

insert into estado values ('Rio de Janeiro',1, 10);
insert into estado values ('Sao Paulo',1, 15);
insert into estado values ('Espirito Santo',1, 20);

insert into estado values ('Buenos Aires',2, 10);

insert into estado values ('Ontario',3, 10);
insert into estado values ('Quebec',3, 15);


DROP FUNCTION mediana(character varying);

CREATE OR REPLACE FUNCTION mediana (arg_pais varchar)
    RETURNS float
    AS $$
    DECLARE       
        areas int[];
        tamanho int;

    BEGIN
        
        Select ARRAY_AGG(area order  by area) 
            from estado e 
            inner join pais p on e.pais = p.codigo 
            where p.nome = arg_pais
            group by codigo 
            into areas;

        IF areas IS NULL THEN 
            RETURN 0; 
        END IF;

        SELECT array_length(areas, 1) INTO tamanho;

        IF tamanho = 1 THEN 
            RETURN areas[1]; 
        END IF;
        IF tamanho%2 = 1 THEN
            RETURN areas[(tamanho/2) +1];
        ELSE 
            RETURN (areas[tamanho/2] + areas[(tamanho/2) +1])/2.0;
        END IF;
        
    END;
$$
LANGUAGE PLPGSQL;


--15
SELECT mediana('Brasil');

--12,5
SELECT mediana('Canada');

--10
SELECT mediana('Argentina');

--0
SELECT mediana('Dinamarca');
