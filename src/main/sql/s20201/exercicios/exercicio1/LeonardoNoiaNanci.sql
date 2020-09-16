DROP TABLE IF EXISTS pessoa CASCADE;

CREATE TABLE pessoa(
    nome VARCHAR,
    endereco VARCHAR
);

INSERT INTO pessoa VALUES('Leonardo Noia Nanci', 'aquela rua lá');
INSERT INTO pessoa VALUES('Luiz', 'IC UFF');

SELECT * FROM pessoa;