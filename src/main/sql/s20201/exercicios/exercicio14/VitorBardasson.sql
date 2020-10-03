--OBS.: AS INFORMAÇÕES DE DURAÇÃO E MÉDIA DE DURAÇÃO ESTÃO EM SEGUNDOS

DROP TABLE IF EXISTS bairro CASCADE;
DROP TABLE IF EXISTS municipio CASCADE;
DROP TABLE IF EXISTS antena CASCADE;
DROP TABLE IF EXISTS ligacao CASCADE;
DROP TABLE IF EXISTS ligacoesregionais;

DO $$ BEGIN
    PERFORM drop_functions();
END $$;


CREATE TABLE bairro (
    bairro_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT bairro_pk PRIMARY KEY (bairro_id)
);

CREATE TABLE municipio (
    municipio_id integer NOT NULL,
    nome character varying NOT NULL,
    CONSTRAINT municipio_pk PRIMARY KEY (municipio_id)
);

CREATE TABLE antena (
    antena_id integer NOT NULL,
    bairro_id integer NOT NULL,
    municipio_id integer NOT NULL,
    CONSTRAINT antena_pk PRIMARY KEY (antena_id),
    CONSTRAINT bairro_fk FOREIGN KEY (bairro_id) REFERENCES bairro(bairro_id),
    CONSTRAINT municipio_fk FOREIGN KEY (municipio_id) REFERENCES municipio(municipio_id)
);

CREATE TABLE ligacao (
    ligacao_id bigint NOT NULL,
    numero_orig integer NOT NULL,
    numero_dest integer NOT NULL,
    antena_orig integer NOT NULL,
    antena_dest integer NOT NULL,
    inicio timestamp NOT NULL,
    fim timestamp NOT NULL,
    CONSTRAINT ligacao_pk PRIMARY KEY (ligacao_id),
    CONSTRAINT antena_orig_fk FOREIGN KEY (antena_orig) REFERENCES antena (antena_id),
    CONSTRAINT antena_dest_fk FOREIGN KEY (antena_dest) REFERENCES antena (antena_id)
);

CREATE TABLE ligacoesregionais (
    bairro1 text NOT NULL,
    municipio1 text NOT NULL,
    bairro2 text NOT NULL,
    municipio2 text NOT NULL,
    lig integer,
    dur integer
);

INSERT INTO municipio VALUES(1, 'Niteroi');
INSERT INTO municipio VALUES(2, 'Rio de Janeiro');

INSERT INTO bairro VALUES (1, 'Centro');
INSERT INTO bairro VALUES (2, 'Ingá');
INSERT INTO bairro VALUES (3, 'São Domingos');
INSERT INTO bairro VALUES (4, 'Icaraí');
INSERT INTO bairro VALUES (5, 'Fonseca');
INSERT INTO bairro VALUES (6, 'Santa Rosa');
INSERT INTO bairro VALUES (7, 'Botafogo');
INSERT INTO bairro VALUES (8, 'Flamengo');
INSERT INTO bairro VALUES (9, 'Tijuca');

INSERT INTO antena VALUES (1, 1, 1);
INSERT INTO antena VALUES (2, 2, 1);
INSERT INTO antena VALUES (3, 3, 1);
INSERT INTO antena VALUES (4, 4, 1);
INSERT INTO antena VALUES (5, 5, 1);
INSERT INTO antena VALUES (6, 6, 1);
INSERT INTO antena VALUES (7, 7, 2);
INSERT INTO antena VALUES (8, 8, 2);
INSERT INTO antena VALUES (9, 9, 2);

INSERT INTO ligacao VALUES (1,0000000000,000000000,1,2,'2020-10-1 0:00:25-07', '2020-10-1 0:03:20-01');
INSERT INTO ligacao VALUES (2,0000000001,000000002,3,4,'2020-10-2 15:00:39-07', '2020-10-2 15:02:25-02');
INSERT INTO ligacao VALUES (3,0000000003,000000004,5,6,'2020-11-5 0:00:25-07', '2020-11-5 0:10:25-00');
INSERT INTO ligacao VALUES (4,0000000005,000000006,8,9,'2019-1-2 12:10:25-07', '2019-1-2 12:20:25-00');
INSERT INTO ligacao VALUES (5,0000000007,000000008,1,2,'2020-10-1 9:02:20-07', '2020-10-1 9:06:10-00');
INSERT INTO ligacao VALUES (6,0000000009,000000010,8,9,'2020-10-1 9:02:20-07', '2020-10-1 9:06:10-00');
INSERT INTO ligacao VALUES (7,0000000011,000000012,8,9,'2020-10-2 9:01:20-07', '2020-10-3 9:02:10-00');

CREATE OR REPLACE FUNCTION media(inicio timestamp, fim timestamp)
    RETURNS TABLE (
        bairro1 text,
        municipio1 text,
        bairro2 text,
        municipio2 text,
        ligacoes int,
        duracao int,
        media float
    )
    AS $$
DECLARE
    curs1 CURSOR FOR SELECT * FROM ligacao;
    t_row record;
    bairro1_aux text;
    bairro2_aux text;
    municipio1_aux text;
    municipio2_aux text;
    lig_aux integer;
    initialtime_aux integer;
    finaltime_aux integer;

BEGIN
    OPEN curs1;    
    LOOP
        FETCH curs1 INTO t_row;
        EXIT WHEN NOT FOUND;
        
        IF t_row.inicio >= inicio AND t_row.fim <= fim THEN
        SELECT nome FROM municipio WHERE municipio_id IN (
            SELECT municipio_id FROM antena WHERE antena_id = t_row.antena_orig
        ) INTO municipio1_aux;
        SELECT nome FROM municipio WHERE municipio_id IN (
            SELECT municipio_id FROM antena WHERE antena_id = t_row.antena_dest
        ) INTO municipio2_aux;
        SELECT nome FROM bairro WHERE bairro_id IN (
            SELECT bairro_id FROM antena WHERE antena_id = t_row.antena_orig
        ) INTO bairro1_aux;
        SELECT nome FROM bairro WHERE bairro_id IN (
            SELECT bairro_id FROM antena WHERE antena_id = t_row.antena_dest
        ) INTO bairro2_aux;

        --extraindo timestamps em segundos
        SELECT ((SELECT EXTRACT(HOUR FROM t_row.inicio::time)) * 60 * 60 + (SELECT EXTRACT (MINUTES FROM t_row.inicio::time) * 60) + (SELECT EXTRACT (SECONDS from t_row.inicio::time))) INTO initialtime_aux;

        SELECT ((SELECT EXTRACT(HOUR FROM t_row.fim::time) * 60 * 60) + (SELECT EXTRACT (MINUTES FROM t_row.fim::time) * 60) + (SELECT EXTRACT (SECONDS from t_row.fim::time))) INTO finaltime_aux;

        --caso os pares não estejam na relacao, inseri-los
        IF NOT EXISTS (SELECT * FROM ligacoesregionais WHERE ligacoesregionais.municipio1=municipio1_aux AND ligacoesregionais.bairro1 = bairro1_aux AND ligacoesregionais.municipio2=municipio2_aux AND ligacoesregionais.bairro2=bairro2_aux) THEN INSERT INTO ligacoesregionais VALUES (bairro1_aux, municipio1_aux, bairro2_aux, municipio2_aux, 1, finaltime_aux - initialtime_aux);

        --se os pares estiverem na relacao, apenas realizar update
        ELSE 
           UPDATE ligacoesregionais SET lig = lig + 1, dur = dur + finaltime_aux - initialtime_aux WHERE ligacoesregionais.municipio1 = municipio1_aux AND ligacoesregionais.municipio2 = municipio2_aux AND ligacoesregionais.bairro1 = bairro1_aux AND ligacoesregionais.bairro2 = bairro2_aux;
        END IF;

        END IF;

    
    END LOOP;
    
    CLOSE curs1;
    RETURN QUERY
    SELECT ligacoesregionais.bairro1, ligacoesregionais.municipio1, ligacoesregionais.bairro2, ligacoesregionais.municipio2, lig, dur, dur/lig::FLOAT FROM ligacoesregionais ORDER BY dur/lig DESC;
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM media('2020-1-1 0:10:25-07', '2020-12-9 12:10:25-07');