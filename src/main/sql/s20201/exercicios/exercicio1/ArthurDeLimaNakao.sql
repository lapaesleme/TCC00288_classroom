DROP TABLE if exists Pessoa cascade;

CREATE TABLE Pessoa(
    name varchar(40),
    address varchar(120)
);

INSERT INTO Pessoa (name, address)
VALUES ('Arthur', 'Endereço Teste');

INSERT INTO Pessoa (name, address)
VALUES ('João', 'Endereço do João');

INSERT INTO Pessoa (name, address)
VALUES ('Maria', 'Endereço da Maria');

SELECT * FROM Pessoa;

SELECT * FROM Pessoa
WHERE name = 'Arthur';