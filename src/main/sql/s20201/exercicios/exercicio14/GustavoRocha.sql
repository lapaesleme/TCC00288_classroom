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
(numero_dest) REFERENCES antena
(antena_id));

DROP TABLE IF EXISTS bairro CASCADE;
CREATE TABLE bairro (
bairro_id integer NOT NULL,
nome character varying NOT NULL,
CONSTRAINT bairro_pk PRIMARY KEY
(bairro_id));

DROP TABLE IF EXISTS municipio CASCADE;
CREATE TABLE municipio (
municipio_id integer NOT NULL,
nome character varying NOT NULL,
CONSTRAINT municipio_pk PRIMARY KEY
(municipio_id));

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



INSERT INTO bairro VALUES(1, 'A');
INSERT INTO bairro VALUES(2, 'B');
INSERT INTO bairro VALUES(3, 'C');
INSERT INTO bairro VALUES(4, 'D');
INSERT INTO bairro VALUES(5, 'E');
INSERT INTO bairro VALUES(6, 'F');
INSERT INTO bairro VALUES(7, 'G');
INSERT INTO bairro VALUES(8, 'H');
INSERT INTO bairro VALUES(9, 'I');

INSERT INTO municipio VALUES(1, 'AA');
INSERT INTO municipio VALUES(2, 'BB');
INSERT INTO municipio VALUES(3, 'CC');

INSERT INTO antena VALUES(1, 1, 1);
INSERT INTO antena VALUES(2, 2, 1);
INSERT INTO antena VALUES(3, 3, 1);
INSERT INTO antena VALUES(4, 4, 2);
INSERT INTO antena VALUES(5, 5, 2);
INSERT INTO antena VALUES(6, 6, 2);
INSERT INTO antena VALUES(7, 7, 3);
INSERT INTO antena VALUES(8, 8, 3);
INSERT INTO antena VALUES(9, 9, 3);

INSERT INTO ligacao VALUES(1, 1, 2, 1, 1, '2000-12-16 12:21:13', '2000-12-16 12:22:13');
INSERT INTO ligacao VALUES(2, 2, 1, 1, 2, '2000-12-17 12:22:35', '2000-12-17 12:24:10');
INSERT INTO ligacao VALUES(3, 3, 7, 1, 1, '2000-12-16 12:20:43', '2000-12-16 12:30:03');
INSERT INTO ligacao VALUES(4, 5, 6, 1, 3, '2000-12-16 09:01:13', '2000-12-16 09:08:34');
INSERT INTO ligacao VALUES(5, 10, 24, 2, 1, '2000-12-16 10:44:21', '2000-12-16 11:00:01');
INSERT INTO ligacao VALUES(6, 11, 14, 2, 2, '2000-12-16 07:04:01', '2000-12-16 07:05:39');
INSERT INTO ligacao VALUES(7, 35, 44, 2, 9, '2000-12-16 23:11:56', '2000-12-16 23:19:06');
INSERT INTO ligacao VALUES(8, 21, 22, 2, 8, '2000-12-16 17:21:13', '2000-12-16 17:22:13');
INSERT INTO ligacao VALUES(9, 55, 74, 2, 4, '2000-12-16 13:21:13', '2000-12-16 13:27:13');
INSERT INTO ligacao VALUES(10, 26, 45, 3, 1, '2000-12-16 12:27:13', '2000-12-16 12:54:13');
INSERT INTO ligacao VALUES(11, 31, 47, 3, 7, '2000-12-16 15:46:13', '2000-12-16 15:58:22');
INSERT INTO ligacao VALUES(12, 79, 85, 3, 8, '2000-12-16 12:38:55', '2000-12-16 12:51:53');
INSERT INTO ligacao VALUES(13, 94, 100, 8, 1, '2000-12-16 14:35:13', '2000-12-16 14:40:00');
INSERT INTO ligacao VALUES(14, 66, 65, 8, 2, '2000-12-16 18:40:13', '2000-12-16 18:43:27');
INSERT INTO ligacao VALUES(15, 420, 69, 6, 3, '2000-12-16 04:20:06', '2000-12-16 04:20:09');
INSERT INTO ligacao VALUES(16, 581, 33, 4, 4, '2000-12-16 05:44:55', '2000-12-16 05:59:59');
INSERT INTO ligacao VALUES(17, 81, 242, 4, 4, '2000-12-16 10:37:27', '2000-12-16 10:47:33');
INSERT INTO ligacao VALUES(18, 197, 201, 3, 6, '2000-12-16 11:55:10', '2000-12-16 12:08:10');



DROP FUNCTION IF EXISTS duracaoMedia(tempoIn timestamp, tempoF timestamp);

CREATE OR REPLACE FUNCTION duracaoMedia(tempoIn timestamp, tempoF timestamp) RETURNS TABLE (bairro character varying, municipio character varying, media float) AS $$
DECLARE
    tempo RECORD;
    participa RECORD;
    ligacoes integer:= 0;
    deltaTime interval := 0;
    nBairro character varying;
    nMunicipio character varying;
    mediaLigacoes  float;
    tempoTotal float;
BEGIN
    FOR participa IN SELECT antena_orig AS antenaParticipante FROM ligacao WHERE inicio >= tempoIn AND fim <= tempoF UNION SELECT antena_dest AS antenaParticipante FROM ligacao WHERE inicio >= tempoIn AND fim <= tempoF LOOP
             
        FOR tempo IN SELECT antena_orig, antena_dest, inicio, fim FROM ligacao WHERE inicio >= tempoIn AND fim <= tempoF LOOP
            IF tempo.antena_orig = participa.antenaParticipante OR tempo.antena_dest = participa.antenaParticipante THEN
                ligacoes = ligacoes + 1;
                deltaTime = deltaTime + tempo.Fim - tempo.inicio;
            END IF;
        END LOOP;
        
        tempoTotal := EXTRACT(second FROM deltaTime)/60;
        tempoTotal := tempoTotal+ EXTRACT (minute fROM deltaTime);
        tempoTotal := tempoTotal + EXTRACT (hour FROM deltaTime)*60;
        tempoTotal := tempoTotal + EXTRACT (day FROM deltaTime)*24 *60;

        SELECT nome FROM bairro WHERE bairro_id IN
        (SELECT bairro_id FROM antena WHERE antena_id = participa.antenaParticipante) INTO nBairro;

        SELECT nome FROM municipio WHERE municipio_id IN 
        (SELECT municipio_id FROM antena WHERE antena_id = participa.antenaParticipante) INTO nMunicipio;
        
        mediaLigacoes := tempoTotal/ligacoes;
        
        RETURN QUERY SELECT nBairro,nMunicipio, mediaLigacoes ;
            
        deltaTime := 0;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM duracaoMedia('2000-12-16 07:00:00','2000-12-16 23:00:00') ORDER BY media DESC;