DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS bairro CASCADE;
CREATE TABLE bairro (
bairro_id integer NOT NULL,
nome character varying NOT NULL,

CONSTRAINT bairro_pk PRIMARY KEY
(bairro_id));

INSERT INTO bairro
    VALUES(0, 'Icaraí');
INSERT INTO bairro
    VALUES(1, 'Fonseca');
INSERT INTO bairro
    VALUES(2, 'Ingá');
INSERT INTO bairro
    VALUES(3, 'Engenhoca');
INSERT INTO bairro
    VALUES(4, 'Jardim Atlântico Oeste');
INSERT INTO bairro
    VALUES(5, 'Praia de Itaipuaçu');
INSERT INTO bairro
    VALUES(6, 'Recanto de Itaipuaçu');
INSERT INTO bairro
    VALUES(7, 'Barroco');

DROP TABLE IF EXISTS municipio CASCADE;
CREATE TABLE municipio (
municipio_id integer NOT NULL,
nome character varying NOT NULL,

CONSTRAINT municipio_pk PRIMARY KEY
(municipio_id));

INSERT INTO municipio
    VALUES(0, 'Niterói');
INSERT INTO municipio
    VALUES(1, 'Maricá');

DROP TABLE IF EXISTS antena CASCADE;
CREATE TABLE antena (
antena_id integer NOT NULL,
bairro_id integer NOT NULL,
municipio_id integer NOT NULL,

CONSTRAINT antena_pk PRIMARY KEY
(antena_id),
CONSTRAINT bairro_fk FOREIGN KEY
(bairro_id) REFERENCES bairro
(bairro_id),
CONSTRAINT municipio_fk FOREIGN KEY
(municipio_id) REFERENCES municipio
(municipio_id));

INSERT INTO antena
    VALUES(0, 0, 0); --antena em Icaraí
INSERT INTO antena
    VALUES(1, 1, 0); --antena no Fonseca
INSERT INTO antena
    VALUES(2, 1, 0); --antena no Fonseca
INSERT INTO antena
    VALUES(3, 2, 0); --antena no Ingá
INSERT INTO antena
    VALUES(4, 3, 0); --antena na Engenhoca
INSERT INTO antena
    VALUES(5, 3, 0); --antena na Engenhoca
INSERT INTO antena
    VALUES(6, 4, 1); --antena no Jardim Antlântico oeste
INSERT INTO antena
    VALUES(7, 5, 1); --antena na Praia de Itaipuaçu
INSERT INTO antena
    VALUES(8, 6, 1); --antena no Recanto
INSERT INTO antena
    VALUES(9, 7, 1); --antena no Barroco
INSERT INTO antena
    VALUES(10, 7, 1); --antena no Barroco
INSERT INTO antena
    VALUES(11, 7, 1); --antena no Barroco

DROP TABLE IF EXISTS ligacao CASCADE;
CREATE TABLE ligacao (
ligacao_id bigint NOT NULL,
numero_orig integer NOT NULL,
numero_dest integer NOT NULL,
antena_orig integer NOT NULL,
antena_dest integer NOT NULL,
inicio timestamp NOT NULL,
fim timestamp NOT NULL,

CONSTRAINT ligacao_pk PRIMARY KEY
(ligacao_id),
CONSTRAINT antena_orig_fk FOREIGN KEY
(antena_orig) REFERENCES antena
(antena_id),
CONSTRAINT antena_dest_fk FOREIGN KEY
(antena_dest) REFERENCES antena
(antena_id));
--YYYY/MM/DD 19:10:25-07
INSERT INTO ligacao
    VALUES(
        0, 99999999, 88888888, 0, 1,
        '2013-07-01 12:00:00', '2013-07-01 12:05:00');
INSERT INTO ligacao
    VALUES(
        1, 88888888, 99999999, 1, 0,
        '2013-07-01 12:30:00', '2013-07-01 12:32:00');
INSERT INTO ligacao
    VALUES(
        2, 77777777, 66666666, 2, 3,
        '2013-07-01 12:22:00', '2013-07-01 12:35:00');
INSERT INTO ligacao
    VALUES(
        3, 55555555, 33333333, 6, 10,
        '2013-07-01 11:30:00', '2013-07-01 11:33:00');

CREATE OR REPLACE FUNCTION media_ligacao(tempo_ini timestamp, tempo_fin timestamp) 
RETURNS TABLE(regiao_orig_lig varchar[2], tempo_medio interval) AS $$
DECLARE
    ligacao_ RECORD;
    bairro_temp varchar;
    municipio_temp varchar;
    regiao_orig varchar[2];
    regiao_dest varchar[2];
BEGIN
    DROP TABLE IF EXISTS listagem;
    CREATE TEMPORARY TABLE listagem(
        id int not null,
        tempo_lig interval,
        regiao_orig varchar[2], --bairro_id, municipio_id
        regiao_dest varchar[2], --bairro_id, municipio_id

        CONSTRAINT classificacao_PK PRIMARY KEY(id)
    );
    FOR ligacao_ IN (SELECT * FROM ligacao 
    WHERE tempo_ini <= inicio AND fim <= tempo_fin) LOOP
        --trecho para pegar o nome do bairro e do municipio
        SELECT b.nome INTO bairro_temp FROM bairro AS b 
        WHERE b.bairro_id = (SELECT bairro_id FROM antena AS a
        WHERE a.antena_id = ligacao_.antena_orig);

        SELECT m.nome INTO municipio_temp FROM municipio AS m 
        WHERE m.municipio_id = (SELECT municipio_id FROM antena AS a
        WHERE a.antena_id = ligacao_.antena_orig);
        
        regiao_orig := array_append(regiao_orig, bairro_temp);
        regiao_orig := array_append(regiao_orig, municipio_temp);

        SELECT b.nome INTO bairro_temp FROM bairro AS b 
        WHERE b.bairro_id = (SELECT bairro_id FROM antena AS a
        WHERE a.antena_id = ligacao_.antena_dest);

        SELECT m.nome INTO municipio_temp FROM municipio AS m 
        WHERE m.municipio_id = (SELECT municipio_id FROM antena AS a
        WHERE a.antena_id = ligacao_.antena_dest);

        regiao_dest := array_append(regiao_dest, bairro_temp);
        regiao_dest := array_append(regiao_dest, municipio_temp);

        IF regiao_orig != regiao_dest THEN
            INSERT INTO listagem
                VALUES(
                    ligacao_.ligacao_id,
                    ligacao_.fim - ligacao_.inicio,
                    regiao_orig,
                    regiao_dest);
        END IF;
        regiao_orig := '{}';
        regiao_dest := '{}';
    END LOOP;
    RETURN QUERY (SELECT l.regiao_orig, AVG(l.tempo_lig) AS media FROM listagem AS l
    GROUP BY l.regiao_orig ORDER BY media DESC);
END;
$$ LANGUAGE plpgsql;


--retorna a duração média das ligações interegionais de cada região
--dado um período de tempo
SELECT * FROM media_ligacao('2013-07-01 11:30:00', '2013-07-01 12:35:00');
