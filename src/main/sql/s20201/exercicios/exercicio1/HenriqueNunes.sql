
DROP TABLE IF EXISTS Pessoa;
CREATE TABLE Pessoa(
    nome varchar(255),
    endereco varchar(255)
);

INSERT INTO Pessoa (nome,endereco) VALUES('Henrique','Endereco');
INSERT INTO Pessoa (nome,endereco) VALUES('Ex_Nome','Ex_Endereco');
INSERT INTO Pessoa (nome,endereco) VALUES('Ex_Nome2','Ex_Endereco2');

SELECT * FROM pessoa;
