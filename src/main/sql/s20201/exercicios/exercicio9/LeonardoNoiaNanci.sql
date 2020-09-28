DROP TABLE IF EXISTS pais CASCADE;
CREATE TABLE pais(
	codigo INTEGER,
	nome VARCHAR
);

DROP TABLE IF EXISTS estado CASCADE;
CREATE TABLE estado(
	nome VARCHAR,
	pais INTEGER,
	area FLOAT
);


INSERT INTO pais VALUES(1, 'Brasil');
INSERT INTO pais VALUES(2, 'Canada');
INSERT INTO estado VALUES('Amazonas', '1', 1571000);
INSERT INTO estado VALUES('Mato Grosso', '1', 903357);
INSERT INTO estado VALUES('Tocantins', '1', 277621);
INSERT INTO estado VALUES('BC', '2', 944735);
INSERT INTO estado VALUES('Alberta', '2', 661848);

-------------------------------------------------------------------

CREATE OR REPLACE FUNCTION computarAreaMediana(VARCHAR)
RETURNS FLOAT AS $$
	DECLARE
		counter INTEGER;
		areas FLOAT[];
		curs CURSOR(nome_pais VARCHAR) FOR
				SELECT area
				FROM pais, estado
				WHERE pais.nome = nome_pais AND
					  pais.codigo = estado.pais
				ORDER BY area;
	
	BEGIN
		counter := 0;
		FOR area IN curs($1) LOOP
			areas := array_append(areas, area.area);
			counter = counter + 1;
		END LOOP;
		
		
		raise notice '%', areas;
		IF counter % 2 = 1 THEN
			return areas[counter/2+1];	
		END IF;
		return (areas[counter/2] + areas[counter/2+1])/2;

	END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------

SELECT computarAreaMediana('Brasil');

SELECT computarAreaMediana('Canada');
