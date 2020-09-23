/**
 * Author:  Philippe Geraldeli
 * Created: 23/09/2020
 */

DROP SEQUENCE IF EXISTS pais_sequence cascade;
DROP TABLE IF EXISTS PAIS cascade;
DROP TABLE IF EXISTS ESTADO cascade;
DROP FUNCTION IF EXISTS mediana(nome varchar) cascade;

CREATE SEQUENCE pais_sequence START 1;
CREATE TABLE PAIS (codigo INTEGER NOT NULL DEFAULT nextval('pais_sequence'), nome VARCHAR(255));
CREATE TABLE ESTADO (nome VARCHAR(255), pais INTEGER NOT NULL, area float);

CREATE FUNCTION mediana(n varchar) RETURNS float AS $$ 
    DECLARE
		pais_codigo integer;
		qtd_estados integer;
		arow 		record;
		array_areas float[];
	BEGIN
		SELECT codigo FROM PAIS WHERE n = pais.nome INTO pais_codigo;
		IF pais_codigo IS NULL THEN
			RETURN 0.0;
		ELSE
			SELECT COUNT(*) FROM ESTADO WHERE pais_codigo = estado.pais INTO qtd_estados;
			
			FOR arow IN (SELECT area FROM ESTADO WHERE pais_codigo = estado.pais ORDER BY area) LOOP
            	array_areas = array_append(array_areas,	arow.area);
        	END LOOP;
			
 			IF qtd_estados % 2 = 0 THEN
				RETURN ((array_areas[qtd_estados/2] + array_areas[qtd_estados/2 + 1]) / 2);
 			ELSE
				RETURN array_areas[qtd_estados/2 + 1];
			END IF;
		END IF;
    END;
	
$$ LANGUAGE plpgsql;



INSERT INTO pais(nome) VALUES ('BRASIL');
INSERT INTO estado(nome,pais,area) VALUES ('Amazonas', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 1559159.1);
INSERT INTO estado(nome,pais,area) VALUES ('Pará', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 1247954.7);
INSERT INTO estado(nome,pais,area) VALUES ('Mato Grosso', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 903366.2);
INSERT INTO estado(nome,pais,area) VALUES ('Minas Gerais', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 586522.1);
INSERT INTO estado(nome,pais,area) VALUES ('Bahia', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 564733.2);
INSERT INTO estado(nome,pais,area) VALUES ('Mato Grosso do Sul', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 357145.5);
INSERT INTO estado(nome,pais,area) VALUES ('Goiás', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 340111.8);
INSERT INTO estado(nome,pais,area) VALUES ('Maranhão', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 331937.4);
INSERT INTO estado(nome,pais,area) VALUES ('Rio Grande do Sul', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 281730.2);
INSERT INTO estado(nome,pais,area) VALUES ('Tocantins', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 277720.5);
INSERT INTO estado(nome,pais,area) VALUES ('Piauí', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 251577.7);
INSERT INTO estado(nome,pais,area) VALUES ('São Paulo', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 248222.8);
INSERT INTO estado(nome,pais,area) VALUES ('Rondônia', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 237590.5);
INSERT INTO estado(nome,pais,area) VALUES ('Roraima', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 224300.5);
INSERT INTO estado(nome,pais,area) VALUES ('Paraná', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 199307.9);
INSERT INTO estado(nome,pais,area) VALUES ('Acre', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 164123.0);
INSERT INTO estado(nome,pais,area) VALUES ('Ceará', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 148920.5);
INSERT INTO estado(nome,pais,area) VALUES ('Amapá', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 142828.5);
INSERT INTO estado(nome,pais,area) VALUES ('Pernambuco', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 98148.3);
INSERT INTO estado(nome,pais,area) VALUES ('Santa Catarina', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 95736.2);
INSERT INTO estado(nome,pais,area) VALUES ('Paraíba', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 56469.8);
INSERT INTO estado(nome,pais,area) VALUES ('Rio Grande do Norte', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 52811.0);
INSERT INTO estado(nome,pais,area) VALUES ('Espírito Santo', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 46095.6);
INSERT INTO estado(nome,pais,area) VALUES ('Rio de Janeiro', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 43780.2);
INSERT INTO estado(nome,pais,area) VALUES ('Alagoas', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 27778.5);
INSERT INTO estado(nome,pais,area) VALUES ('Sergipe', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 21915.1);
INSERT INTO estado(nome,pais,area) VALUES ('Distrito Federal', (SELECT codigo FROM PAIS WHERE pais.nome = 'BRASIL'), 5780.0);

INSERT INTO pais(nome) VALUES ('teste');
INSERT INTO estado(nome,pais,area) VALUES ('teste1', (SELECT codigo FROM PAIS WHERE pais.nome = 'teste'), 2);
INSERT INTO estado(nome,pais,area) VALUES ('teste1', (SELECT codigo FROM PAIS WHERE pais.nome = 'teste'), 3);

SELECT mediana('BRASIL'); -- impar

SELECT mediana('teste'); -- par

SELECT mediana('inexistente'); -- null
