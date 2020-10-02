DROP TABLE IF EXISTS campeonato CASCADE;
DROP TABLE IF EXISTS time_ CASCADE;
DROP TABLE IF EXISTS jogo CASCADE;

CREATE TABLE campeonato (
    codigo TEXT NOT NULL,
	nome TEXT NOT NULL,
	ano INTEGER NOT NULL,
    CONSTRAINT campeonato_pk
        PRIMARY KEY (codigo));

CREATE TABLE time_ (
    sigla TEXT NOT NULL,
	nome TEXT NOT NULL,
	CONSTRAINT time_pk
		PRIMARY KEY (sigla));

CREATE TABLE jogo(
	campeonato TEXT NOT NULL, 
	numero INTEGER NOT NULL,
	time1 TEXT NOT NULL,
	time2 TEXT NOT NULL,
	gols1 INTEGER NOT NULL,
	gols2 INTEGER NOT NULL,
	data_ DATE NOT NULL DEFAULT CURRENT_DATE,
	CONSTRAINT jogo_pk
		PRIMARY KEY (campeonato,numero),
	CONSTRAINT jogo_campeonato_fk
		FOREIGN KEY	(campeonato)
		REFERENCES campeonato (codigo),
	CONSTRAINT jogo_time_fk1
		FOREIGN KEY	(time1)
		REFERENCES time_ (sigla),
	CONSTRAINT jogo_time_fk2
		FOREIGN KEY	(time2)
		REFERENCES time_ (sigla));

INSERT INTO campeonato VALUES('1', 'Brasileiro', 2019);

INSERT INTO time_ VALUES('FLA', 'Flamengo'),
						('PAL', 'Palmeiras'),
						('SAN', 'Santos'),
						('GRE', 'Gremio');

INSERT INTO jogo VALUES('1', 1, 'FLA', 'PAL', 7, 7),
						('1', 2, 'FLA', 'SAN', 1, 0),
						('1', 3, 'FLA', 'GRE', 5, 0),
						('1', 4, 'PAL', 'SAN', 1, 2),
						('1', 5, 'PAL', 'GRE', 3, 2),
						('1', 6, 'SAN', 'GRE', 0, 1),
						('1', 7, 'SAN', 'FLA', 0, 4),
						('1', 8, 'GRE', 'FLA', 0, 1),
						('1', 9, 'PAL', 'FLA', 0, 0),
						('1', 10, 'GRE', 'PAL', 0, 0),
						('1', 11, 'GRE', 'SAN', 1, 0),
                        ('1', 12, 'SAN', 'PAL', 1, 0);

----------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION classificacao(codigo TEXT, pos1 INTEGER, pos2 INTEGER)
RETURNS TABLE(Time_ TEXT, Pontos INTEGER, V INTEGER, E INTEGER, D INTEGER) AS $$
	DECLARE
		times CURSOR(cod TEXT) FOR
			SELECT sigla FROM time_ WHERE sigla IN (SELECT time1
													FROM jogo
													WHERE campeonato = cod) OR
										  sigla IN (SELECT time2
													FROM jogo
													WHERE campeonato = cod);
		
		
    BEGIN
		DROP TABLE IF EXISTS ans;
		CREATE TEMPORARY TABLE ans(Time_ TEXT,
									Pontos INTEGER,
									V INTEGER,
									E INTEGER,
									D INTEGER);

        FOR timeX IN times(codigo) LOOP
		
			-- Vitórias
			SELECT COUNT(*) FROM jogo WHERE (time1 = timeX.sigla AND gols1 > gols2) OR
				  							(time2 = timeX.sigla and gols2 > gols1)
			INTO V;
			
			-- Empates
			SELECT COUNT(*) FROM jogo WHERE (time1 = timeX.sigla OR time2 = timeX.sigla) AND gols1 = gols2
			INTO E;
			
			-- Derrotas
			SELECT COUNT(*) FROM jogo WHERE (time1 = timeX.sigla AND gols1 < gols2) OR
	  										(time2 = timeX.sigla and gols2 < gols1)
			INTO D;
			
			Pontos := V * 3 + E;
			Time_ := timeX.sigla;
			
			INSERT INTO ans VALUES(Time_, Pontos, V, E, D);
			
		END LOOP;

		RETURN QUERY SELECT * FROM ans ORDER BY(ans.Pontos, ans.V) DESC LIMIT pos2 OFFSET pos1;
    END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------

SELECT * FROM classificacao('1', 0, 4);
SELECT * FROM classificacao('1', 0, 2);