DROP TABLE IF EXISTS bairro CASCADE;
DROP TABLE IF EXISTS municipio CASCADE;
DROP TABLE IF EXISTS antena CASCADE;
DROP TABLE IF EXISTS ligacao CASCADE;

CREATE TABLE bairro (
	bairro_id integer NOT NULL,
	nome character varying NOT NULL,
	CONSTRAINT bairro_pk
		PRIMARY KEY	(bairro_id));
	
CREATE TABLE municipio (
	municipio_id integer NOT NULL,
	nome character varying NOT NULL,
	CONSTRAINT municipio_pk
		PRIMARY KEY	(municipio_id));
	
CREATE TABLE antena (
	antena_id integer NOT NULL,
	bairro_id integer NOT NULL,
	municipio_id integer NOT NULL,
	CONSTRAINT antena_pk
		PRIMARY KEY	(antena_id),
	CONSTRAINT bairro_fk
		FOREIGN KEY	(bairro_id)
		REFERENCES bairro (bairro_id),
	CONSTRAINT municipio_fk
		FOREIGN KEY (municipio_id)
		REFERENCES municipio (municipio_id));
	
CREATE TABLE ligacao (
	ligacao_id bigint NOT NULL,
	numero_orig integer NOT NULL,
	numero_dest integer NOT NULL,
	antena_orig integer NOT NULL,
	antena_dest integer NOT NULL,
	inicio timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fim timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT ligacao_pk
		PRIMARY KEY	(ligacao_id),
	CONSTRAINT antena_orig_fk
		FOREIGN KEY	(antena_orig)
		REFERENCES antena (antena_id),
	CONSTRAINT antena_dest_fk
		FOREIGN KEY	(antena_dest)
		REFERENCES antena (antena_id));

INSERT INTO bairro VALUES(1, 'São Cristóvão'),
						 (2, 'Maracanã'),
						 (3, 'Icaraí'),
						 (4, 'Gragoatá');

INSERT INTO municipio VALUES(1, 'Rio de Janeiro'),
							(2, 'Niteroi');

INSERT INTO antena VALUES(1, 1, 1),
						 (2, 2, 1),
						 (3, 3, 2),
						 (4, 3, 2),
						 (5, 4, 2);

INSERT INTO ligacao VALUES(1, 2525, 2323, 1, 1, '2020-09-30 04:00:00', '2020-09-30 04:10:00'),	-- São cristóvão -> São Cristóvão	| 10min
						  (2, 2552, 3693, 1, 2, '2020-09-30 04:00:00', '2020-09-30 04:15:00'),	-- São cristóvão -> Maracanã		| 15min
						  (3, 2525, 2323, 1, 3, '2020-09-30 04:00:00', '2020-09-30 04:20:00'),	-- São cristóvão -> Icaraí			| 20min
						  (4, 2866, 2323, 1, 4, '2020-09-30 04:00:00', '2020-09-30 04:25:00'),	-- São cristóvão -> Icaraí			| 25min
						  (5, 2525, 2323, 2, 1, '2020-09-30 04:00:00', '2020-09-30 04:30:00'),	-- Maracanã 	 -> São Cristóvão	| 30min
						  (6, 2525, 2323, 2, 2, '2020-09-30 04:00:00', '2020-09-30 04:35:00'),	-- Maracanã 	 -> Maracanã		| 35min
						  (7, 2525, 2323, 2, 3, '2020-09-30 04:00:00', '2020-09-30 04:40:00'),	-- Maracanã 	 -> Icaraí			| 40min
						  (8, 2525, 2323, 2, 4, '2020-09-30 04:00:00', '2020-09-30 04:45:00'),	-- Maracanã 	 -> Icaraí			| 45min
						  (9, 2525, 2323, 3, 1, '2020-09-30 04:00:00', '2020-09-30 04:50:00'),	-- Icaraí 		 -> São Cristóvão	| 50min
						  (10, 2525, 2323, 3, 2, '2020-09-30 04:00:00', '2020-09-30 04:55:00'),	-- Icaraí 		 -> Maracanã		| 55min
						  (11, 2525, 2323, 3, 3, '2020-09-30 04:00:00', '2020-09-30 05:00:00'),	-- Icaraí 		 -> Icaraí			| 1h
						  (12, 2525, 2323, 3, 4, '2020-09-30 04:00:00', '2020-09-30 05:05:00'),	-- Icaraí 		 -> Icaraí			| 1h05min
						  (13, 2525, 2323, 4, 1, '2020-09-30 04:00:00', '2020-09-30 05:10:00'),	-- Icaraí 		 -> São Cristóvão	| 1h10min
						  (14, 2525, 2323, 4, 2, '2020-09-30 04:00:00', '2020-09-30 05:15:00'),	-- Icaraí 		 -> Maracanã		| 1h15min
						  (15, 2525, 2323, 4, 3, '2020-09-30 04:00:00', '2020-09-30 05:20:00'),	-- Icaraí 		 -> Icaraí			| 1h20min
						  (16, 2525, 2323, 4, 4, '2020-09-30 04:00:00', '2020-09-30 05:25:00');	-- Icaraí 		 -> Icaraí			| 1h25min

---------------------------------------------------------------------

CREATE OR REPLACE FUNCTION duracao_media(data_hora_ini TIMESTAMP, data_hora_fim TIMESTAMP)
RETURNS TABLE(municipio1 TEXT, bairro1 TEXT, municipio2 TEXT, bairro2 TEXT, tempo_medio TIME) AS $$
	DECLARE
		crossRegioes CURSOR FOR
			SELECT regiao1.municipio_id M1, regiao1.bairro_id B1, regiao2.municipio_id M2, regiao2.bairro_id B2
			FROM (SELECT DISTINCT bairro_id, municipio_id
      			  FROM antena) AS regiao1,
      			 (SELECT DISTINCT bairro_id, municipio_id
      			  FROM antena) AS regiao2;

		media CURSOR(b1 INTEGER, m1 INTEGER, b2 INTEGER, m2 INTEGER) FOR
			SELECT AVG(fim - inicio)
			FROM ligacao
			WHERE antena_orig IN (SELECT antena_id
								  FROM antena
								  WHERE bairro_id = b1 AND municipio_id = m1) AND
				antena_dest IN (SELECT antena_id
								FROM antena
								WHERE bairro_id = b2 AND municipio_id = m2) AND
				(data_hora_ini, data_hora_fim) OVERLAPS (ligacao.inicio, ligacao.fim);
					
    BEGIN
		DROP TABLE IF EXISTS ans;
		CREATE TEMPORARY TABLE ans(municipio1 TEXT,
									bairro1 TEXT,
									municipio2 TEXT,
									bairro2 TEXT,
									tempo_medio TIME);

        FOR dupla IN crossRegioes LOOP

			OPEN media(dupla.B1, dupla.M1, dupla.B2, dupla.M2);
			FETCH media INTO tempo_medio;
			CLOSE media;

			IF tempo_medio IS NULL THEN
				tempo_medio = '00:00:00';
			END IF;

			SELECT nome FROM municipio WHERE municipio_id = dupla.M1 INTO municipio1;
			SELECT nome FROM municipio WHERE municipio_id = dupla.M2 INTO municipio2;
			SELECT nome FROM bairro WHERE bairro_id = dupla.B1 INTO bairro1;
			SELECT nome FROM bairro WHERE bairro_id = dupla.B2 INTO bairro2;

			RAISE NOTICE '% % % % %', municipio1, bairro1, municipio2, bairro2, tempo_medio;

			INSERT INTO ans VALUES(municipio1, bairro1, municipio2, bairro2, tempo_medio);

		END LOOP;

		RETURN QUERY SELECT * FROM ans ORDER BY tempo_medio DESC;

    END;
$$ LANGUAGE plpgsql;

SELECT * FROM duracao_media('2020-09-30 03:00:00'::TIMESTAMP, '2020-09-30 06:00:00'::TIMESTAMP);