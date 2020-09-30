drop table if exists pais;
create table pais( codigo integer, nome varchar);

drop table if exists estado;
create table estado(nome varchar, pais varchar, area integer);

insert into pais(codigo,nome) values
(1,'brasil'),
(2,'china');

insert into estado(nome, pais, area) values
('rj','brasil',43696),
('sp','brasil',248209),
('br','brasil',5902),
('mt','brasil',903357),
('sc','brasil',95356),
('pequim','china',16808);

drop function if exists mediana;
CREATE FUNCTION mediana(nome_pais varchar) 
RETURNS integer 
AS $$

DECLARE
    areasResult integer[];
    aEstado RECORD;
BEGIN
    areasResult = '{}';

    FOR aEstado IN SELECT area FROM pais, estado WHERE pais.nome = estado.pais ORDER BY area ASC LOOP
        areasResult = array_append(areasResult, aEstado.area);
    END LOOP;

    IF array_length(areasResult,1) IS NULL THEN
        RETURN 0;
    END IF;

    IF array_length(areasResult, 1)%2 = 0 THEN
        RETURN (areasResult[array_length(areasResult, 1)/2]+areasResult[array_length(areasResult, 1)/2 + 1])/2;
    END IF;

    RETURN areasResult[ROUND(array_length(areasResult, 1)::numeric/2)];
END;
$$ LANGUAGE plpgsql;


select * from mediana('brasil');

