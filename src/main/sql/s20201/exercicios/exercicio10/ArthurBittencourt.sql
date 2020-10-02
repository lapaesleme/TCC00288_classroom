DO $$ BEGIN 
PERFORM drop_functionS();
END $$;


DROP TABLE IF EXISTS empregado CASCADE;
CREATE TABLE empregado(
empregado_id integer,
nome varchar,
salario real,
adcional_dep real
);

INSERT INTO empregado VALUES(
1, 'Testina', 2500, 100 );
INSERT INTO empregado VALUES(
2, 'Ronase', 5000, 100 );
INSERT INTO empregado VALUES(
3, 'Jajitania', 4800, 100 );

DROP TABLE IF EXISTS dependente CASCADE;
CREATE TABLE dependente(
empregado_id integer,
seq smallint, --eu nao tenho ideia do que isso deveria significar
nome varchar
);

INSERT INTO dependente VALUES(
1, 123, 'Testina JR');
INSERT INTO dependente VALUES(
1, 456, 'Testina JR JR');
INSERT INTO dependente VALUES(
1, 789, 'Testina JR JR JR');
INSERT INTO dependente VALUES(
2, 132, 'Cachorro da Ronase');
INSERT INTO dependente VALUES(
2, 465, 'Definitavemente não sou um dependente fantasma');
INSERT INTO dependente VALUES(
2, 798, 'Reuda');

DROP FUNCTION IF EXISTS depadd(eid integer);
CREATE FUNCTION depadd(eid integer) RETURNS integer AS $$

DECLARE

    i integer; 
    c integer;
    d float;

BEGIN
    c := 0;
    FOR i IN SELECT * FROM dependente WHERE empregado_id = eid LOOP
        c := c + 1;
    END LOOP; 
    
    d := 1 + (c * 0.05);

    UPDATE empregado SET adcional_dep = adcional_dep * d WHERE empregado_id = eid;

RETURN 0;
END;

$$ LANGUAGE plpgsql;

SELECT * FROM empregado;
SELECT depadd(1);
SELECT * FROM empregado;