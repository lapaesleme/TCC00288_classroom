drop function if exists computarAreaMediana(nomePais varchar) cascade;
drop table if exists pais cascade;
drop table if exists estado cascade;

CREATE TABLE pais (
    codigo integer,
    nome varchar,
    PRIMARY KEY(codigo)
);

CREATE TABLE estado (
    nome varchar,
    pais integer,
    area float,
    CONSTRAINT fk_pais
        FOREIGN KEY(pais)
            REFERENCES pais(codigo)
);

INSERT INTO pais VALUES (1, 'Estados Unidos');
INSERT INTO pais VALUES (2, 'Brasil');

INSERT INTO estado VALUES ('Rio de Janeiro', 2, 1255);
INSERT INTO estado VALUES ('Rio Grande de Sul', 2, 281748);
INSERT INTO estado VALUES ('Amazonas', 2, 1571000);
INSERT INTO estado VALUES ('Acre', 2, 152581);
INSERT INTO estado VALUES ('São Paulo', 2, 248209);
INSERT INTO estado VALUES ('Tocantins', 2, 277621);

INSERT INTO estado VALUES ('Massachusetts', 1, 27363);
INSERT INTO estado VALUES ('Florida', 1, 170304);
INSERT INTO estado VALUES ('California', 1, 423970);


CREATE or REPLACE FUNCTION computarAreaMediana(nomePais varchar) RETURNS float AS $$
DECLARE
    areasResult float[];
    aEstado RECORD;
BEGIN
    
    areasResult = '{}';
    
    FOR aEstado IN SELECT area FROM pais, estado WHERE pais.codigo = estado.pais AND pais.nome = nomePais ORDER BY area ASC LOOP
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


select * from computarAreaMediana('Estados Unidos'); /* Numero impar de estados */
select * from computarAreaMediana('Lituania'); /* Nao existe */
select * from computarAreaMediana('Brasil'); /* Numero par de estados */

