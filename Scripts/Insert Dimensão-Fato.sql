
/*==============================================================*/ 
/*TRUNCATE TABLE                                     */ 
/*==============================================================*/ 
TRUNCATE TABLE DIM_ORGAO_SUPERIOR; 

TRUNCATE TABLE DIM_ORGAO_SUBORDINADO; 

TRUNCATE TABLE DIM_MODALIDADE_DESPESA; 

TRUNCATE TABLE DIM_GRUPO_DESPESA; 

TRUNCATE TABLE DIM_FUNCAO_DESPESA; 

TRUNCATE TABLE FATO_DESPESA; 
TRUNCATE TABLE FATO_RECEITA; 

/*==============================================================*/ 
/*INSERT CASOS ESPECIAIS                                     */ 
/*==============================================================*/ 
SET IDENTITY_INSERT DIM_MODALIDADE_DESPESA ON 

INSERT INTO DIM_MODALIDADE_DESPESA 
            (SK_MODALIDADE_DESPESA, 
             COD_MODALIDADE_DESPESA, 
             MODALIDADE_DESPESA, 
             DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1 -- NUMHORA - INT 
              , 
              'NÃO INFORMADO' -- DSCHORA - VARCHAR(15) 
              , 
              '1900-01-01' -- DTHINICIOVIGENCIA - DATETIME 
) 

SET IDENTITY_INSERT DIM_MODALIDADE_DESPESA OFF 

GO 

SET IDENTITY_INSERT DIM_ORGAO_SUBORDINADO ON 

INSERT INTO DIM_ORGAO_SUBORDINADO 
            (SK_ORGAO_SUBORDINADO, 
             COD_ORGAO_SUBORDINADO, 
             NOME_ORGAO_SUBORDINADO, 
             DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1 -- NUMHORA - INT 
              , 
              'NÃO INFORMADO' -- DSCHORA - VARCHAR(15) 
              , 
              '1900-01-01' -- DTHINICIOVIGENCIA - DATETIME 
) 

SET IDENTITY_INSERT DIM_ORGAO_SUBORDINADO OFF 

GO 


SET IDENTITY_INSERT DIM_GRUPO_DESPESA ON 

INSERT INTO DIM_GRUPO_DESPESA 
            (SK_GRUPO_DESPESA, 
             COD_GRUPO_DESPESA, 
             NOME_GRUPO_DESPESA, 
             DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1, 
              'NÃO SE APLICA', 
              '1900-01-01' ) 

SET IDENTITY_INSERT DIM_GRUPO_DESPESA OFF 

GO 

SET IDENTITY_INSERT DIM_FUNCAO_DESPESA ON 

INSERT INTO DIM_FUNCAO_DESPESA 
            (SK_FUNCAO_DESPESA, 
             COD_FUNCAO_DESPESA, 
             NOME_FUNCAO_DESPESA, 
             DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1, 
              'NÃO SE APLICA', 
              '1900-01-01' ) 

SET IDENTITY_INSERT DIM_FUNCAO_DESPESA OFF 

GO 

SET IDENTITY_INSERT FATO_DESPESA ON 

INSERT INTO FATO_DESPESA 
            (SK_FT_DESPESA, 
             SK_ORGAO_SUPERIOR, 
             SK_MODALIDADE_DESPESA, 
             SK_ORGAO_SUBORDINADO, 
             SK_DIM_TEMPO, 
             SK_FUNCAO_DESPESA, 
             SK_GRUPO_DESPESA, 
             VR_EMPENHADO, 
             VR_LIQUIDO, 
             VR_PAGO, 
             VR_RESTO_PAGAR_INSCRITO, 
             VR_RETO_PAGAR_CANCELADO, 
             VR_RESTO_PAGAR_PAGO, 
             DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1, 
              -1, 
              -1, 
              -1, 
              -1, 
              -1, 
              0, 
              0, 
              0, 
              0, 
              0, 
              0, 
              '1900-01-01' ) 

SET IDENTITY_INSERT FATO_DESPESA OFF 


GO 

SET IDENTITY_INSERT FATO_RECEITA ON 

INSERT INTO FATO_RECEITA 
       (SK_FT_RECEITA
      ,SK_ORGAO_SUPERIOR
      ,SK_ORGAO_SUBORDINADO
      ,SK_DIM_TEMPO
      ,VALOR_PREVISTO_ATUALIZADO
      ,VALOR_LANCADO
      ,VALOR_REALIZADO
      ,PERCENTUAL_REALIZADO
      ,DT_ATUALIZACAO) 
VALUES      ( -1, 
              -1, 
              -1, 
              -1, 
              0, 
              0, 
              0, 
              0, 
              '1900-01-01' ) 

SET IDENTITY_INSERT FATO_RECEITA OFF 


GO

/*==============================================================*/ 
/* INSERT DIMENSÃO                        */ 
/*==============================================================*/ 
INSERT INTO DIM_FUNCAO_DESPESA 
SELECT DISTINCT COD_FUNCAO, 
                NOME_FUNCAO, 
                FORMAT(GETDATE(), 'yyyy-MM-dd') 
FROM   STG_DESPESA_PUBLICA 
WHERE  COD_FUNCAO NOT IN( -1 ) 
ORDER  BY 1 

/*==============================================================*/ 
/*TABELA  DIM_GRUPO_DESPESA                                       */ 
/*==============================================================*/ 
INSERT INTO DIM_GRUPO_DESPESA 
SELECT DISTINCT COD_GRUPO_DESPESA, 
                NOME_GRUPO_DESPESA, 
                FORMAT(GETDATE(), 'yyyy-MM-dd') 
FROM   STG_DESPESA_PUBLICA 
ORDER  BY 1 

/*==============================================================*/ 
/*TABELA DIM_ORGAO_SUPERIOR                                      */ 
/*==============================================================*/ 
INSERT INTO DIM_ORGAO_SUPERIOR 
SELECT  DISTINCT 
      A.COD_ORGAO_SUPERIOR
      ,A.NOME_ORGAO_SUPERIOR
   
      ,FORMAT(GETDATE(), 'yyyy-MM-dd') 
   FROM STG_DESPESA_PUBLICA AS A

/*==============================================================*/ 
/*TABELA DIM_ORGÃO SUBORDINADOS                                    */ 
/*==============================================================*/ 
INSERT INTO DIM_ORGAO_SUBORDINADO 
SELECT DISTINCT COD_ORGAO_SUBORDINADO, 
                NOME_ORGAO_SUBORDINADO 
                ,FORMAT(GETDATE(), 'yyyy-MM-dd') 
FROM   STG_DESPESA_PUBLICA 
GO
/*==============================================================*/ 
/*TABELA DIM_MODALIDADE DE DESPESA                                  */ 
/*==============================================================*/ 
INSERT INTO DIM_MODALIDADE_DESPESA 
SELECT DISTINCT COD_MODALIDADE_DESPESA, 
                MODALIDADE_DESPESA, 
                FORMAT(GETDATE(), 'yyyy-MM-dd') 
FROM   STG_DESPESA_PUBLICA 

GO
/*==============================================================*/ 
/*APAGA OS REGISTROS DUPLICADOS DA DIM_MODALIDADE DE DESPESA                                  */ 
/*==============================================================*/ 
  DELETE FROM [DIM_MODALIDADE_DESPESA] 
  WHERE MODALIDADE_DESPESA<(SELECT MAX(MODALIDADE_DESPESA)  
  FROM [DIM_MODALIDADE_DESPESA] T2 
  WHERE [DIM_MODALIDADE_DESPESA].COD_MODALIDADE_DESPESA=T2.COD_MODALIDADE_DESPESA)
GO 



--/*==============================================================*/ 
--/*TABELA FATO_DESPESA                                        */ 
--/*==============================================================*/ 
INSERT INTO FATO_DESPESA 
SELECT 

 ISNULL(DIM_ORG_SU.SK_ORGAO_SUPERIOR, -1) AS SK_ORGAO_SUPERIOR, 
       ISNULL(MODA.SK_MODALIDADE_DESPESA, -1)   AS SK_MODALIDADE_DESPESA, 
       ISNULL(DIM_SUB.SK_ORGAO_SUBORDINADO, -1) AS SK_ORGAO_SUBORDINADO, 
       ISNULL(T.SK_DIM_TEMPO, -1)               AS SK_DIM_TEMPO, 
       ISNULL(DMFUN.SK_FUNCAO_DESPESA, -1)      AS SK_FUNCAO_DESPESA, 
       ISNULL(DIMGP.SK_GRUPO_DESPESA, -1)       AS SK_GRUPO_DESPESA, 
       STG.VR_EMPENHADO, 
       STG.VR_LIQUIDO, 
       STG.VR_PAGO, 
       STG.VR_RESTO_PAGAR_INSCRITO, 
       STG.VR_RETO_PAGAR_CANCELADO, 
       STG.VR_RESTO_PAGAR_PAGO, 
       GETDATE()                                AS DT 
FROM   STG_DESPESA_PUBLICA AS STG 
       LEFT JOIN DIM_ORGAO_SUPERIOR AS DIM_ORG_SU 
              ON STG.COD_ORGAO_SUPERIOR = DIM_ORG_SU.COD_ORGAO_SUPERIOR 
       LEFT JOIN DIM_ORGAO_SUBORDINADO AS DIM_SUB 
              ON STG.COD_ORGAO_SUBORDINADO = DIM_SUB.COD_ORGAO_SUBORDINADO 
       LEFT JOIN DIM_MODALIDADE_DESPESA AS MODA 
              ON STG.COD_MODALIDADE_DESPESA = MODA.COD_MODALIDADE_DESPESA 
       LEFT JOIN DIM_FUNCAO_DESPESA AS DMFUN 
              ON STG.COD_FUNCAO = DMFUN.COD_FUNCAO_DESPESA 
       LEFT JOIN DIM_GRUPO_DESPESA AS DIMGP 
              ON STG.COD_GRUPO_DESPESA = DIMGP.COD_GRUPO_DESPESA
	left JOIN (
    SELECT DISTINCT REPLACE(DATA,'-','') sk_data 
	, max( SK_DIM_TEMPO)  SK_DIM_TEMPO  
	FROM  DBO.DIM_TEMPO
   GROUP BY MES, REPLACE(DATA,'-','')
        ) T ON  REPLACE(STG.EXERCICIO,'/','')	= T.sk_data 

				  
--/*==============================================================*/ 
--/*TABELA FATO_RECEITA                                        */ 
--/*==============================================================*/ 			  
				  
				  
INSERT INTO FATO_RECEITA
SELECT
 ISNULL(ORG_SU.SK_ORGAO_SUPERIOR, -1)       AS SK_ORGAO_SUPERIOR, 
       ISNULL(ORG_SUBO.SK_ORGAO_SUBORDINADO, -1)  AS SK_ORGAO_SUBORDINADO, 
       ISNULL(T.SK_DIM_TEMPO, -1)                 AS SK_DIM_TEMPO, 
       ISNULL(STG.VALOR_PREVISTO_ATUALIZADO, 0) AS VALOR_PREVISTO_ATUALIZADO 
       , 
       ISNULL(STG.VALOR_LANCADO, 0)             AS VALOR_LANCADO, 
       ISNULL(STG.VALOR_REALIZADO, 0)           AS VALOR_REALIZADO, 
       ISNULL(STG.PERCENTUAL_REALIZADO, 0)      AS PERCENTUAL_REALIZADO, 
       GETDATE()                                  DT_ATUALIZACAO
      
FROM   STG_RECEITA AS STG 
      inner JOIN DIM_ORGAO_SUPERIOR AS ORG_SU 
            ON STG.CODIGO_ORGAO_SUPERIOR = ORG_SU.COD_ORGAO_SUPERIOR 
      LEFT JOIN DIM_ORGAO_SUBORDINADO AS ORG_SUBO 
             ON STG.CODIGO_ORGAO = ORG_SUBO.COD_ORGAO_SUBORDINADO 
     INNER JOIN (
    SELECT DISTINCT  ANO,MAX(SK_DIM_TEMPO) SK_DIM_TEMPO 
	FROM  DBO.DIM_TEMPO
  GROUP BY ANO
   
        ) T ON STG.ANO_EXERCICIO =T.ANO 







/*==============================================================*/ 
/*DROP CONSTRAINTS  FATO_DESPESA                              */ 
/*==============================================================*
ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DES_DIM_MODAL_DIM_MODA; 

GO 

ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DES_DIM_ORGAO_DIM_ORGA; 

GO 

ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DES_DIM_ORGAO_SUPERIOR; 

GO 

ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DES_DIM_TEMPO_DIM_TEMP; 

GO 

ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DES_DIM_GRUPO_DESPESA; 

GO 

ALTER TABLE FATO_DESPESA 
  DROP CONSTRAINT FK_FATO_DIM_FUNCAO_DESPESA; 

GO 


/*==============================================================*/ 
/*DROP CONSTRAINTS  FATO_RECEITA                                     */ 
/*==============================================================*
ALTER TABLE FATO_RECEITA 
  DROP CONSTRAINT FK_FATO_RES_DIM_ORGAO_DIM_ORGA; 

GO 
ALTER TABLE FATO_RECEITA 
  DROP CONSTRAINT FK_FATO_RES_DIM_ORGAO_SUBORDINADO_DIM_ORGAO_SUBORDINADO; 

GO 
ALTER TABLE FATO_RECEITA 
  DROP CONSTRAINT FK_FATO_RES_DIM_TEMPO_DIM_TEMP; 


/*==============================================================*/ 
/*ADD CONSTRAINTS   FATO_DESPESA                             */ 
/*==============================================================*
ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DES_DIM_MODAL_DIM_MODA FOREIGN KEY ( 
  SK_MODALIDADE_DESPESA) REFERENCES DIM_MODALIDADE_DESPESA ( 
  SK_MODALIDADE_DESPESA) 

ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DES_DIM_ORGAO_DIM_ORGA FOREIGN KEY ( 
  SK_ORGAO_SUBORDINADO) REFERENCES DIM_ORGAO_SUBORDINADO (SK_ORGAO_SUBORDINADO) 

ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DES_DIM_ORGAO_SUPERIOR FOREIGN KEY (SK_ORGAO_SUPERIOR) 
  REFERENCES DIM_ORGAO_SUPERIOR (SK_ORGAO_SUPERIOR) 

ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DES_DIM_TEMPO_DIM_TEMP FOREIGN KEY (SK_DIM_TEMPO) 
  REFERENCES DBO.DIM_TEMPO (SK_DIM_TEMPO) 

ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DIM_FUNCAO_DESPESA FOREIGN KEY (SK_FUNCAO_DESPESA) 
  REFERENCES DBO.DIM_FUNCAO_DESPESA (SK_FUNCAO_DESPESA) 

ALTER TABLE FATO_DESPESA 
  ADD CONSTRAINT FK_FATO_DES_DIM_GRUPO_DESPESA FOREIGN KEY (SK_GRUPO_DESPESA) 
  REFERENCES DBO.DIM_GRUPO_DESPESA (SK_GRUPO_DESPESA) 

/*==============================================================*/ 
/*ADD CONSTRAINTS   FATO_RECEITA                             */ 
/*==============================================================* 

ALTER TABLE FATO_RECEITA 
  ADD CONSTRAINT FK_FATO_RES_DIM_ORGAO_DIM_ORGA FOREIGN KEY ( SK_ORGAO_SUPERIOR)
  REFERENCES DIM_ORGAO_SUPERIOR (SK_ORGAO_SUPERIOR) 
    
  
  ALTER TABLE FATO_RECEITA 
  ADD CONSTRAINT FK_FATO_RES_DIM_ORGAO_SUBORDINADO_DIM_ORGAO_SUBORDINADO FOREIGN KEY ( SK_ORGAO_SUBORDINADO)
  REFERENCES DIM_ORGAO_SUBORDINADO (SK_ORGAO_SUBORDINADO) 
  
  
  
  ALTER TABLE FATO_RECEITA 
  ADD CONSTRAINT FK_FATO_RES_DIM_TEMPO_DIM_TEMP FOREIGN KEY ( SK_DIM_TEMPO)
  REFERENCES DIM_TEMPO (SK_DIM_TEMPO) 
  */
  
  