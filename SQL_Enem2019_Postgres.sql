DROP TABLE micdados;
SELECT Count(nu_inscricao) FROM micdados;
SELECT Count(nu_inscricao) FROM micdados 
   WHERE SG_UF_RESIDENCIA='MG';
   
---- 1a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  
---- 2a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_LC)
FROM micdados
WHERE NU_NOTA_LC is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  
---- 3a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND TP_SEXO = 'F'

---- 4a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND TP_SEXO = 'M'
	  
---- 5a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND NO_MUNICIPIO_RESIDENCIA = 'Montes Claros'
	  AND TP_SEXO = 'F'

---- 6a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND NO_MUNICIPIO_RESIDENCIA = 'Sabará'
	  AND Q021 = 'B'
	  
---- 7a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND Q016 = 'C'
	  
---- 8a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND Q002 = 'G'
	  
---- 9a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
      AND ( NO_MUNICIPIO_RESIDENCIA = 'Belo Horizonte' OR
	        NO_MUNICIPIO_RESIDENCIA = 'Conselheiro Lafaiete')
			
---- 10a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
      AND Q005 = 1
	  
---- 11a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
      AND Q001 = 'G'
	  AND Q006 = 'M'
	  
---- 12a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND TP_SEXO = 'F'
      AND NO_MUNICIPIO_RESIDENCIA = 'Lavras'
	  AND TP_LINGUA = 1
	  
---- 13a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND TP_SEXO = 'M'
      AND NO_MUNICIPIO_RESIDENCIA = 'Ouro Preto'

---- 14a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_CH)
FROM micdados
WHERE NU_NOTA_CH is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND IN_SURDEZ = 1
	  
---- 159a. QUSTÃO --------------  
SELECT 
	avg(NU_NOTA_MT)
FROM micdados
WHERE NU_NOTA_MT is not null
      AND SG_UF_RESIDENCIA = 'MG'
	  AND TP_SEXO = 'F'
	  AND IN_DISLEXIA = 1
      AND ( NO_MUNICIPIO_RESIDENCIA = 'Belo Horizonte' OR
	        NO_MUNICIPIO_RESIDENCIA = 'Sabará' OR
	        NO_MUNICIPIO_RESIDENCIA = 'Nova Lima'OR
	        NO_MUNICIPIO_RESIDENCIA = 'Betim')