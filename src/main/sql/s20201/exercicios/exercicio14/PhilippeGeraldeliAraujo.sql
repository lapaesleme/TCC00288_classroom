
DO $$ BEGIN
    PERFORM drop_functions();
END $$;

DROP TABLE IF EXISTS bairro cascade;
DROP TABLE IF EXISTS municipio cascade;
DROP TABLE IF EXISTS antena cascade;
DROP TABLE IF EXISTS ligacao cascade;

DROP SEQUENCE IF EXISTS bairro_sequence;
CREATE SEQUENCE bairro_sequence START 1;

DROP SEQUENCE IF EXISTS municipio_sequence;
CREATE SEQUENCE municipio_sequence START 1;

DROP SEQUENCE IF EXISTS antena_sequence;
CREATE SEQUENCE antena_sequence START 1;

DROP SEQUENCE IF EXISTS ligacao_sequence;
CREATE SEQUENCE ligacao_sequence START 1;

CREATE TABLE bairro (
    bairro_id integer NOT NULL DEFAULT nextval('bairro_sequence'),
    nome character varying NOT NULL,
    CONSTRAINT bairro_pk PRIMARY KEY
    (bairro_id));

CREATE TABLE municipio (
    municipio_id integer NOT NULL DEFAULT nextval('municipio_sequence'),
    nome character varying NOT NULL,
    CONSTRAINT municipio_pk PRIMARY KEY
    (municipio_id));

CREATE TABLE antena (
    antena_id integer NOT NULL DEFAULT nextval('antena_sequence'),
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

CREATE TABLE ligacao (
    ligacao_id bigint NOT NULL DEFAULT nextval('ligacao_sequence'),
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

INSERT INTO bairro(nome) VALUES ('Valonguinho'), ('Itaipu'), ('Engenho do mato');

INSERT INTO municipio(nome) VALUES ('Niterói');

INSERT INTO antena (bairro_id, municipio_id) VALUES 
((SELECT bairro_id FROM bairro where bairro.nome = 'Valonguinho'), (SELECT municipio_id FROM municipio WHERE municipio.nome = 'Niterói')),
((SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu'), (SELECT municipio_id FROM municipio WHERE municipio.nome = 'Niterói')),
((SELECT bairro_id FROM bairro where bairro.nome = 'Engenho do mato'), (SELECT municipio_id FROM municipio WHERE municipio.nome = 'Niterói'));


INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('123456789',
    '987654321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Valonguinho')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')),
                '2017-03-31 9:40:20', '2017-03-31 10:30:20');
				
INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('125234189',
    '982224321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Valonguinho')),
                '2017-03-31 9:50:20', '2017-03-31 10:00:20');
				
INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('123516789',
    '987654321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Valonguinho')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')),
                '2017-03-31 4:30:20', '2017-03-31 10:30:20');

INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('121116789',
    '987444321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Engenho do mato')),
                '2017-03-31 10:00:20', '2017-03-31 10:30:20');

INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('121116789',
    '987444321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Engenho do mato')),
                '2017-03-31 9:50:20', '2017-03-31 10:30:20');

INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('121116789',
    '987444321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Itaipu')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Engenho do mato')),
                '2017-03-31 4:30:20', '2017-03-31 10:30:20');

INSERT INTO ligacao 
(numero_orig,numero_dest,antena_orig,antena_dest,inicio,fim)
VALUES 
('121116789',
    '987444321',
        (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Valonguinho')), 
            (SELECT antena_id FROM antena WHERE bairro_id = (SELECT bairro_id FROM bairro where bairro.nome = 'Engenho do mato')),
                '2017-03-31 4:30:20', '2017-03-31 10:30:20');

CREATE OR REPLACE FUNCTION duracao_ligacao(inicio_param timestamp, fim_param timestamp) RETURNS TABLE(par_antena_dest_origem varchar(255), duracao_media interval) AS $$
    DECLARE
        antena_aux RECORD;
        ligacao_aux RECORD;
        destino_origem_aux varchar(255);
		duracao_ligacao interval;
    BEGIN
        DROP TABLE IF EXISTS temp_tabela;
        CREATE TEMP TABLE temp_tabela(destino_origem varchar(255), duracao interval);

        FOR ligacao_aux IN SELECT * FROM ligacao WHERE ligacao.inicio >= inicio_param AND ligacao.fim <= fim_param LOOP
		
			IF ligacao_aux.antena_orig > ligacao_aux.antena_dest THEN
				destino_origem_aux := concat(ligacao_aux.antena_dest,ligacao_aux.antena_orig);
			ELSE
				destino_origem_aux := concat(ligacao_aux.antena_orig,ligacao_aux.antena_dest);
			END IF;
			
            duracao_ligacao := ligacao_aux.fim - ligacao_aux.inicio;
            RAISE NOTICE 'antena_origem , antena_destino: %', destino_origem_aux;
			RAISE NOTICE 'duracao_ligacao: %', duracao_ligacao;
            INSERT INTO temp_tabela VALUES (destino_origem_aux, duracao_ligacao);
        END LOOP;

        RETURN QUERY (SELECT  destino_origem, AVG(duracao) OVER (PARTITION BY destino_origem) FROM temp_tabela);
    END;
$$ LANGUAGE plpgsql;

SELECT DISTINCT * FROM duracao_ligacao('2017-03-31 0:30:20', '2017-03-31 23:59:59');  
