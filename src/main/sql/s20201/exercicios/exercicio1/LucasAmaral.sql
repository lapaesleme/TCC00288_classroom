/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  Gabri
 * Created: 14 de set. de 2020
 */

DROP TABLE IF EXISTS pessoa CASCADE;

CREATE TABLE pessoa(
    nome VARCHAR,
    endereco VARCHAR
);

INSERT INTO pessoa VALUES('Lucas Amaral', 'Teste');
INSERT INTO pessoa VALUES('Lucas', 'Teste2');

SELECT * FROM pessoa;