


--===============================================================================
--SCRIPT DE CRIAÇÃO TABELA HADOOP - HIVE_BI_TB_E_PMV_PAP
--===============================================================================

CREATE TABLE IF NOT EXISTS `bi.tb_e_pmv_pap`(	
    `num_pedido` string,
    `dt_ped_realizado` string,
    `hr_ped_realizado` string,
    `dt_ped_tratado` string,
    `hr_ped_tratado` string,
    `produto_oi` string,
    `status_pedido` string,
    `motivo_nao_venda` string,
    `sub_motivo_nao_venda` string,
    `numero_os` string,
    `empresa` string,
    `reg_ddd` string,
    `reg_uf` string,
    `fluxo_orig` string,
    `dt_evento` string)
ROW FORMAT SERDE 	
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 	
STORED AS INPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 	
OUTPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'	
TBLPROPERTIES (	
  'parquet.compress'='SNAPPY')	


--===============================================================================
--SCRIPT DE INSERÇÃO TABELA HADOOP - HIVE_BI_TB_E_PMV_PAP
--===============================================================================

INSERT OVERWRITE TABLE  bi.tb_e_pmv_pap
SELECT 
     regexp_replace(`numero do pedido`,'"','') as num_pedido
    ,regexp_replace(`data em que o pedido foi realizado`,'"','') as dt_ped_realizado
    ,regexp_replace(`Hora em que o pedido foi realizado`,'"','') as hr_ped_realizado
    ,regexp_replace(`data em que o pedido foi tratado`,'"','') as dt_ped_tratado
    ,regexp_replace(`Hora em que o pedido foi tratado`,'"','') as hr_ped_tratado
    ,regexp_replace(`produto oi`,'"','') as produto_oi
    ,regexp_replace(`status do pedido`,'"','') as status_pedido
    ,regexp_replace(`motivo de nao venda`,'"','') as motivo_nao_venda
    ,regexp_replace(`sub-motivo de nao venda`,'"','') as sub_motivo_nao_venda
    ,regexp_replace(`numero os`,'"','') as numero_os
    ,regexp_replace(`empresa`,'"','') as empresa
    ,regexp_replace(`regionalizaacaoddd`,'"','') as reg_ddd
    ,regexp_replace(`regionalizacaouf`,'"','') as reg_uf
    ,regexp_replace(`fluxo de origem`,'"','') as fluxo_orig
    ,dt_evento
from prd_digital_pap.vw_ext_ec_prd 
where regexp_replace(`data em que o pedido foi realizado`,'"','') = '<<PARM1>>'

----- View em HML : bi.tb_temp_pap

---- REGRA PAP CORREÇÃO TIMEZONE - em TB_
INSERT OVERWRITE TABLE  bi.tb_e_pmv_pap
SELECT 
     regexp_replace(`numero do pedido`,'"','') as num_pedido
    ,'<<PARM1>>' as dt_ped_realizado
    ,CASE 
        WHEN substr(`Hora em que o pedido foi realizado`,2,2) = '00'
            THEN concat('21', substr(`Hora em que o pedido foi realizado`,4,6))
        WHEN substr(`Hora em que o pedido foi realizado`,2,2) = '01'
            THEN concat('22', substr(`Hora em que o pedido foi realizado`,4,6))
        WHEN substr(`Hora em que o pedido foi realizado`,2,2) = '02'
            THEN concat('23', substr(`Hora em que o pedido foi realizado`,4,6))
        ELSE substr(`Hora em que o pedido foi realizado`,2,8)
        END AS hr_ped_realizado
    ,regexp_replace(`data em que o pedido foi tratado`,'"','') as dt_ped_tratado
    ,regexp_replace(`Hora em que o pedido foi tratado`,'"','') as hr_ped_tratado
    ,regexp_replace(`produto oi`,'"','') as produto_oi
    ,regexp_replace(`status do pedido`,'"','') as status_pedido
    ,regexp_replace(`motivo de nao venda`,'"','') as motivo_nao_venda
    ,regexp_replace(`sub-motivo de nao venda`,'"','') as sub_motivo_nao_venda
    ,regexp_replace(`numero os`,'"','') as numero_os
    ,regexp_replace(`empresa`,'"','') as empresa
    ,regexp_replace(`regionalizaacaoddd`,'"','') as reg_ddd
    ,regexp_replace(`regionalizacaouf`,'"','') as reg_uf
    ,regexp_replace(`fluxo de origem`,'"','') as fluxo_orig
    ,dt_evento
from prd_digital_pap.vw_ext_ec_prd 
where regexp_replace(`data em que o pedido foi realizado`,'"','') BETWEEN '<<PARM1>>' and '<<PARM2>>' and
      ((regexp_replace(`data em que o pedido foi realizado`,'"','') = '<<PARM1>>' and
           substr(`Hora em que o pedido foi realizado`,2,2) NOT IN ('00','01','02')) or
          (regexp_replace(`data em que o pedido foi realizado`,'"','') = <<PARM2>> and
           substr(`Hora em que o pedido foi realizado`,2,2) IN ('00','01','02'))) 


===============================================================================
SCRIPT DE CRIAÇÃO TABELA HADOOP - HIVE_BI_TB_I_PMV_PAP
===============================================================================

CREATE TABLE IF NOT EXISTS `bi.tb_i_pmv_pap`(	
    `num_pedido` string,
    `dt_ped_realizado` string,
    `hr_ped_realizado` string,
    `dt_ped_tratado` string,
    `hr_ped_tratado` string,
    `produto_oi` string,
    `status_pedido` string,
    `motivo_nao_venda` string,
    `sub_motivo_nao_venda` string,
    `numero_os` string,
    `empresa` string,
    `reg_ddd` string,
    `reg_uf` string,
    `fluxo_orig` string,
    `dt_evento` string,
    `pt_anomes` string)
ROW FORMAT SERDE 	
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 	
STORED AS INPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 	
OUTPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'	
TBLPROPERTIES (	
  'parquet.compress'='SNAPPY')	

===============================================================================
SCRIPT DE INSERÇÃO TABELA HADOOP - HIVE_BI_TB_I_DET_PMV_PAP
===============================================================================

set hive.exec.dynamic.partition=true;
set mapred.job.name=PMV_PAP_INSERT;

INSERT OVERWRITE TABLE bi.tb_i_pmv_pap 
select
  num_pedido,	
  dt_ped_realizado,
  hr_ped_realizado,
  dt_ped_tratado,
  hr_ped_tratado,
  produto_oi,
  status_pedido,
  motivo_nao_venda,
  sub_motivo_nao_venda,
  numero_os,
  empresa,
  reg_ddd,
  reg_uf,
  fluxo_orig,
  dt_evento,
  pt_anomes
FROM bi.tb_t_det_pmv_pap
WHERE pt_anomes = '<<PARM1>>' and
      dt_ped_realizado <> '<<PARM2>>';

INSERT INTO TABLE  bi.tb_i_pmv_pap
select
  num_pedido,	
  dt_ped_realizado,
  hr_ped_realizado,
  dt_ped_tratado,
  hr_ped_tratado,
  produto_oi,
  status_pedido,
  motivo_nao_venda,
  sub_motivo_nao_venda,
  numero_os,
  empresa,
  reg_ddd,
  reg_uf,
  fluxo_orig,
  dt_evento,
  '<<PARM1>>' as pt_anomes
FROM bi.tb_e_det_pmv_pap;

===============================================================================
SCRIPT DE CRIAÇÃO TABELA HADOOP - HIVE_BI_TB_T_PMV_PAP
===============================================================================

CREATE TABLE IF NOT EXISTS `bi.tb_t_pmv_pap`(	
    `num_pedido` string,
    `dt_ped_realizado` string,
    `hr_ped_realizado` string,
    `dt_ped_tratado` string,
    `hr_ped_tratado` string,
    `produto_oi` string,
    `status_pedido` string,
    `motivo_nao_venda` string,
    `sub_motivo_nao_venda` string,
    `numero_os` string,
    `empresa` string,
    `reg_ddd` string,
    `reg_uf` string,
    `fluxo_orig` string,
    `dt_evento` string)
PARTITIONED BY ( 	
  `pt_anomes` string COMMENT 'AnoMes referencia do dado')
ROW FORMAT SERDE 	
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 	
STORED AS INPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 	
OUTPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'	
TBLPROPERTIES (	
  'parquet.compress'='SNAPPY')	

===============================================================================
SCRIPT DE INSERÇÃO TABELA HADOOP - HIVE_BI_TB_T_DET_PMV_PAP
===============================================================================

set hive.exec.dynamic.partition=true;
set mapred.job.name=PMV_PAP_TB_T_INSERT;

INSERT OVERWRITE TABLE  bi.tb_t_pmv_pap PARTITION (pt_anomes)
select
  num_pedido,	
  dt_ped_realizado,
  hr_ped_realizado,
  dt_ped_tratado,
  hr_ped_tratado,
  produto_oi,
  status_pedido,
  motivo_nao_venda,
  sub_motivo_nao_venda,
  numero_os,
  reg_ddd,
  reg_uf,
  fluxo_orig,
  dt_evento,
  '<<PARM1>>' AS PT_ANOMES
FROM bi.tb_i_det_pmv_pap;












===============================================================================
SCRIPT DE CRIAÇÃO D TABELA/VIEW  TEMPORÁRIAINSERÇÃO EM HML - BI.TB_TEMP_PAP
===============================================================================
CREATE TABLE IF NOT EXISTS `bi.tb_temp_pap`(	
    `num_pedido`string,
    `dt_ped_realizado`string,
    `hr_ped_realizado`string,
    `dt_ped_tratado`string,
    `hr_ped_tratado`string,
    `tp_cliente`string,
    `nome_cliente`string,
    `cpf`string,
    `e-mail`string,
    `tel_fixo`string,
    `tel_cont1`string,
    `tel_cont2`string,
    `cep`string,
    `uf`string,
    `cidade`string,
    `endereco`string,
    `numero`string,
    `bairro`string,
    `produto_oi`string,
    `plano`string,
    `plano_antigo`string,
    `fidelizado`string,
    `forma_pagto`string,
    `valor_antigo`string,
    `valor_novo`string,
    `delta_ticket`string,
    `status_pedido`string,
    `motivo_nao_venda`string,
    `sub_moivo_nao_venda`string,
    `numero_os`string,
    `numero_contrato`string,
    `login_trat`string,
    `empresa`string,
    `visit_origin`string,
    `session_id`string,
    `utm_term`string,
    `utm_content`string,
    `source_name`string,
    `utm_source`string,
    `utm_campaing`string,
    `utm_medium`string,
    `pagina`string,
    `origem`string,
    `button_origin`string,
    `movel_cli_nao_solic`string,
    `movel_cli_solic`string,
    `tv_cli_nao_solic`string,
    `tv_cli_solic`string,
    `blarga_cli_nao_solic`string,
    `blarga_cli_solic`string,
    `fixo_cli_nao_solic`string,
    `fixo_cli_solic`string,
    `observ`string,
    `ponto_adic`string,
    `grav_digit`string,
    `but_orig_checkout`string,
    `but_orig_conver`string,
    `but_orig_detalhe`string,
    `but_orig_prod`string,
    `operat_system`string,
    `planos`string,
    `qtd_depend`string,
    `reg_cidade`string,
    `reg_ddd`string,
    `reg_uf`string,
    `skuoffer`string,
    `addon_1`string,
    `addon_2`string,
    `addon_3`string,
    `addon_4`string,
    `addon_5`string,
    `addon_6`string,
    `addon_7`string,
    `addon_8`string,
    `addon_9`string,
    `addon_10`string,
    `tp_registro`string,
    `device`string,
    `fluxo_orig`string,
    `mm_oferta_camp_ecommerce`string,
    `mm_camp_ecommerce`string,
    `ds_tecnol_combo`string,
    `plano_contrat`string,
    `ds_velocidade`string,
    `dt_evento`string)
ROW FORMAT SERDE 	
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe' 	
STORED AS INPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat' 	
OUTPUTFORMAT 	
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'	
TBLPROPERTIES (	
  'parquet.compress'='SNAPPY')	


  




 CREATE VIEW `prd_digital_pap.vw_ext_ec_prd` AS SELECT	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo1` ,'"')AS `Numero do pedido`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo2` ,'"')AS `Data em que o pedido foi realizado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo3` ,'"')AS `Hora em que o pedido foi realizado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo4` ,'"')AS `Data em que o pedido foi tratado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo5` ,'"')AS `Hora em que o pedido foi tratado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo6` ,'"')AS `Tipo de Cliente`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo7` ,'"')AS `Nome Completo Cliente`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo8` ,'"')AS `CPF`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo9` ,'"')AS `E-mail`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo10`,'"') AS `Telefone Fixo`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo11`,'"') AS `Telefone de Contato 1`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo12`,'"') AS `Telefone de Contato 2`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo13`,'"') AS `CEP`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo14`,'"') AS `UF`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo15`,'"') AS `Cidade`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo16`,'"') AS `Endereco`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo17`,'"') AS `Numero`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo18`,'"') AS `Bairro`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo19`,'"') AS `Produto Oi`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo20`,'"') AS `Plano`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo21`,'"') AS `Plano Antigo`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo22`,'"') AS `Fidelizado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo23`,'"') AS `Forma de Pagamento`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo24`,'"') AS `Valor Antigo`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo25`,'"') AS `Valor Novo`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo26`,'"') AS `Delta Ticket`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo27`,'"') AS `Status do Pedido`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo28`,'"') AS `Motivo de Nao Venda`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo29`,'"') AS `Sub-Motivo de Nao Venda`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo30`,'"') AS `Numero OS`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo31`,'"') AS `NumeroContrato`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo32`,'"') AS `LoginTratamento`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo33`,'"') AS `Empresa`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo34`,'"') AS `visitOrigin`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo35`,'"') AS `hst_source`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo36`,'"') AS `Session ID`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo37`,'"') AS `Utm_term`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo38`,'"') AS `Utm_content`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo39`,'"') AS `source name`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo40`,'"') AS `utm source`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo41`,'"') AS `utm campaing`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo42`,'"') AS `utm medium`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo43`,'"') AS `pagina`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo44`,'"') AS `origem`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo45`,'"') AS `buttonOrigin`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo46`,'"') AS `Movel(Cliente Nao Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo47`,'"') AS `Movel(Cliente Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo48`,'"') AS `TV(cliente Nao Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo49`,'"') AS `TV(Cliente Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo50`,'"') AS `Banda Larga(Cliente Nao Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo51`,'"') AS `Banda Larga(Cliente Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo52`,'"') AS `Fixo(Cliente Nao Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo53`,'"') AS `Fixo(Cliente Solicitou)`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo54`,'"') AS `OBSERVACAO`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo55`,'"') AS `Ponto Adicional`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo56`,'"') AS `Gravador Digital`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo57`,'"') AS `buttonorigincheckout`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo58`,'"') AS `buttonoriginconversacional`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo59`,'"') AS `buttonorigindetalhe`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo60`,'"') AS `buttonoriginproduto`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo61`,'"') AS `operatingsystem`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo62`,'"') AS `planos`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo63`,'"') AS `quantidadedependentes`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo64`,'"') AS `regionalizacaocidade`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo65`,'"') AS `regionalizaacaoddd`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo66`,'"') AS `regionalizacaouf`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo67`,'"') AS `skuoffer`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo68`,'"') AS `addon 1`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo69`,'"') AS `addon 2`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo70`,'"') AS `addon 3`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo71`,'"') AS `addon 4`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo72`,'"') AS `addon 5`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo73`,'"') AS `addon 6`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo74`,'"') AS `addon 7`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo75`,'"') AS `addon 8`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo76`,'"') AS `addon 9`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo77`,'"') AS `addon 10`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo78`,'"') AS `tp_registro`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo79`,'"') AS `device`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo80`,'"') AS `Fluxo de Origem`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo81`,'"') AS `nm_oferta_campanha_ecommerce`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo82`,'"') AS `nm_campanha_ecommerce`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo83`,'"') AS `ds_tecnologia_combo`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo84`,'"') AS `plano_contratado`,	
CONCAT('"',`tbl_ecom_analitico_prd`.`campo85`,'"') AS `ds_velocidade`,	
`tbl_ecom_analitico_prd`.`dt_evento`	
FROM	
`prd_digital_pap`.`tbl_ecom_analitico_prd`	
WHERE	
`tbl_ecom_analitico_prd`.`tp_relatorio` in ('EC','RENT')	
