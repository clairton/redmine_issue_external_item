USE external_db;

GO 
CREATE TABLE PD_PRODUTOS (codigo INT, ativo CHAR, nome NVARCHAR(50), handle NVARCHAR(50), filial INT, ALMOXARIFADOESTOQUE INT);
GO

INSERT 
    INTO PD_PRODUTOS(codigo, ativo, nome, handle, filial, ALMOXARIFADOESTOQUE)
    VALUES(1, 'S', 'caneta', 'ABC123', 20, 3);
/*
SELECT
  handle AS "key",
  nome AS description
FROM
  PD_PRODUTOS
WHERE
  ALMOXARIFADOESTOQUE = 3
  and ativo = 'S'
  and filial = 24
  and codigo NOT IN (443)
ORDER BY
  description
*/