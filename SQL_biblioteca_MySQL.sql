-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Biblioteca
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Biblioteca
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Biblioteca` DEFAULT CHARACTER SET utf8 ;
USE `Biblioteca` ;

-- -----------------------------------------------------
-- Table `Biblioteca`.`areaconhecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`areaconhecimento` (
  `idareaconhecimento` INT NOT NULL AUTO_INCREMENT COMMENT 'Id AUtonumérico',
  `descricao` VARCHAR(70) NULL COMMENT 'Nome da Área de Conhecimento\n\n\n',
  PRIMARY KEY (`idareaconhecimento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Biblioteca`.`editoras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`editoras` (
  `ideditoras` INT NOT NULL AUTO_INCREMENT,
  `nomeeditora` VARCHAR(70) NOT NULL,
  `cidade` VARCHAR(40) NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ideditoras`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Biblioteca`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`usuarios` (
  `idusuarios` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(80) NOT NULL,
  `cpf` VARCHAR(15) NOT NULL,
  `rg` VARCHAR(20) NULL,
  `datanasc` DATE NULL,
  `sexo` VARCHAR(20) NULL,
  `email` VARCHAR(60) NOT NULL,
  `cep` VARCHAR(15) NULL,
  `logradouro` VARCHAR(80) NOT NULL,
  `num` VARCHAR(6) NOT NULL,
  `bairro` VARCHAR(80) NOT NULL,
  `cidade` VARCHAR(80) NULL,
  `uf` VARCHAR(2) NULL,
  `fone1` VARCHAR(20) NOT NULL,
  `fone2` VARCHAR(20) NULL,
  `status` VARCHAR(20) NULL,
  PRIMARY KEY (`idusuarios`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Biblioteca`.`obras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`obras` (
  `idobras` INT NOT NULL AUTO_INCREMENT,
  `tituloobra` VARCHAR(45) NOT NULL,
  `numero_edicao` INT NOT NULL,
  `ano_edicao` INT NOT NULL,
  `editoras_ideditoras` INT NOT NULL,
  `idioma` VARCHAR(80) NULL,
  `areaconhecimento_idareaconhecimento` INT NOT NULL,
  `ISBN` VARCHAR(45) NULL,
  PRIMARY KEY (`idobras`, `editoras_ideditoras`, `areaconhecimento_idareaconhecimento`),
  CONSTRAINT `fk_obras_editoras1`
    FOREIGN KEY (`editoras_ideditoras`)
    REFERENCES `Biblioteca`.`editoras` (`ideditoras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_obras_areaconhecimento1`
    FOREIGN KEY (`areaconhecimento_idareaconhecimento`)
    REFERENCES `Biblioteca`.`areaconhecimento` (`idareaconhecimento`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_obras_editoras1_idx` ON `Biblioteca`.`obras` (`editoras_ideditoras` ASC) VISIBLE;

CREATE INDEX `fk_obras_areaconhecimento1_idx` ON `Biblioteca`.`obras` (`areaconhecimento_idareaconhecimento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Biblioteca`.`autores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`autores` (
  `idautores` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(70) NULL,
  `paisnascimento` VARCHAR(45) NULL,
  PRIMARY KEY (`idautores`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Biblioteca`.`exeplarobras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`exeplarobras` (
  `idexeplarobras` INT NOT NULL AUTO_INCREMENT,
  `obras_idobras` INT NOT NULL,
  `isbnexemplar` VARCHAR(45) NULL,
  `id_exemplar` INT NOT NULL,
  `situacaoexemplar` VARCHAR(80) NOT NULL,
  `dtaquisicao` DATE NOT NULL,
  PRIMARY KEY (`idexeplarobras`, `obras_idobras`),
  CONSTRAINT `fk_exeplarobras_obras1`
    FOREIGN KEY (`obras_idobras`)
    REFERENCES `Biblioteca`.`obras` (`idobras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_exeplarobras_obras1_idx` ON `Biblioteca`.`exeplarobras` (`obras_idobras` ASC) VISIBLE;

CREATE UNIQUE INDEX `ident_exemplar` ON `Biblioteca`.`exeplarobras` (`isbnexemplar` ASC, `idexeplarobras` ASC, `dtaquisicao` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Biblioteca`.`emprestimos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`emprestimos` (
  `idemprestimos` INT NOT NULL AUTO_INCREMENT,
  `exeplarobras_idexeplarobras` INT NOT NULL,
  `usuarios_idusuarios` INT NOT NULL,
  `dt_emprestimo` DATE NOT NULL,
  `dt_prev_devol` DATE NOT NULL,
  `dt_devol` DATE NULL,
  `hr_devol` TIME NULL,
  PRIMARY KEY (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`),
  CONSTRAINT `fk_emprestimos_usuarios1`
    FOREIGN KEY (`usuarios_idusuarios`)
    REFERENCES `Biblioteca`.`usuarios` (`idusuarios`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emprestimos_exeplarobras1`
    FOREIGN KEY (`exeplarobras_idexeplarobras`)
    REFERENCES `Biblioteca`.`exeplarobras` (`idexeplarobras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_emprestimos_usuarios1_idx` ON `Biblioteca`.`emprestimos` (`usuarios_idusuarios` ASC) VISIBLE;

CREATE INDEX `fk_emprestimos_exeplarobras1_idx` ON `Biblioteca`.`emprestimos` (`exeplarobras_idexeplarobras` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Biblioteca`.`obras_has_autores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Biblioteca`.`obras_has_autores` (
  `obras_idobras` INT NOT NULL,
  `autores_idautores` INT NOT NULL,
  PRIMARY KEY (`obras_idobras`, `autores_idautores`),
  CONSTRAINT `fk_obras_has_autores_obras1`
    FOREIGN KEY (`obras_idobras`)
    REFERENCES `Biblioteca`.`obras` (`idobras`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_obras_has_autores_autores1`
    FOREIGN KEY (`autores_idautores`)
    REFERENCES `Biblioteca`.`autores` (`idautores`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `fk_obras_has_autores_autores1_idx` ON `Biblioteca`.`obras_has_autores` (`autores_idautores` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `Biblioteca`.`areaconhecimento`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (1, 'Espiritualismo');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (2, 'Infanto-Juvenil');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (3, 'Economia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (4, 'Medicina');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (5, 'literatura nacional');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (6, 'história');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (7, 'Fantasia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (8, 'filosofia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (9, 'tecnologia da informação');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (10, 'Comédia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (11, 'Economia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (12, 'Saúde');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (13, 'Nutrição');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (14, 'Matemática');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (15, 'Astronomia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (16, 'literatura  estrangeira');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (17, 'artes');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (18, 'entretenimento');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (19, 'administração e negócios');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (20, 'engenharia');
INSERT INTO `Biblioteca`.`areaconhecimento` (`idareaconhecimento`, `descricao`) VALUES (21, 'sociologia');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`editoras`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (1, 'Casa dos Espiritos', 'Brasil', 'Porto Alegre');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (2, 'Editora Lê', 'Brasil', 'Belo Horizonte');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (3, 'Id Editora', 'Brasil', '');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (4, 'Objetiva', 'Brasil', '');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (5, 'Manole', 'Brasil', 'Rio de Janeiro');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (6, 'Novo Conceito', 'Brasil', '');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (7, 'Benvirá', 'Brasil', '');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (8, 'Scipione', 'Inglaterra', 'Londres');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (9, 'Atica', 'Inglaterra', '');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (10, 'Campus', 'Brasil', 'Rio de Janeiro');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (11, 'Novatec', 'Brasil', 'São Paulo');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (12, 'Bookman', 'Estados Unidos', 'Boston');
INSERT INTO `Biblioteca`.`editoras` (`ideditoras`, `nomeeditora`, `cidade`, `pais`) VALUES (13, 'Record', 'Estados Unidos', 'Miami');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`usuarios`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (1, 'Mariana Fátima Viana', '17587654968', '185600827', '24/06/1963', 'Feminino', 'marianafatimaviana@sheilabenavente.com.br', '69314533', 'Rua Cândido Pereira', '987', 'Doutor Sílvio Botelho', 'Boa Vista', 'RR', '9537490617', '95986602819', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (2, 'Jéssica Daniela da Mata', '22803230445', '428875907', '19/02/1954', 'Feminino', 'jessicadanieladamata-92@thibe.com.br', '74713240', 'Rua Guaiaquil', '605', 'Jardim Novo Mundo', 'Goiânia', 'GO', '6228169418', '62998439117', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (3, 'Juan Paulo Pereira', '9779961828', '484305256', '27/11/1943', 'Masculino', 'juanpaulopereira_@magicday.com.br', '69901758', 'Rua Arco-íris', '605', 'Vitória', 'Rio Branco', 'AC', '6826298043', '68999318454', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (4, 'Elias Raul Teixeira', '36878713129', '380335566', '11/3/1960', 'Masculino', 'eeliasraulteixeira@bat.com', '77403230', 'Rua 3', '478', 'Jardim Eldorado', 'Gurupi', 'TO', '6335431427', '63987244742', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (5, 'Marcos Vinicius Bento Fogaça', '37362747004', '165559299', '9/5/2001', 'Masculino', 'marcosviniciusbentofogaca@yaooh.com', '71261330', 'Quadra Quadra 3 Conjunto 25', '208', 'Setor Leste (Vila Estrutural - Guará)', 'Brasília', 'DF', '6139883293', '61996206560', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (6, 'Rafaela Isabel Raimunda Aparício', '1017588635', '467470571', '7/4/1984', 'Feminino', 'rafaelaisabelraimundaaparicio-92@arablock.com.br', '57083064', 'Vila Padre Cícero', '850', 'Antares', 'Maceió', 'AL', '8228640060', '82985070436', 'Suspenso');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (7, 'Ana Louise Agatha Galvão', '74652481241', '329087575', '19/05/1960', 'Feminino', 'aanalouiseagathagalvao@abdalathomaz.adv.br', '54410323', '1ª Travessa Maria Rita Barradas', '909', 'Piedade', 'Jaboatão dos Guararapes', 'PE', '8127840834', '81997453396', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (8, 'Analu Evelyn Milena Aparício', '48892704508', '488384667', '20/05/1950', 'Feminino', 'analuevelynmilenaaparicio_@yahool.com.br', '78731432', 'Rua Gv-22', '401', 'Setor Residencial Granville II', 'Rondonópolis', 'MT', '6637208818', '66999067930', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (9, 'Francisca Julia Gonçalves', '67463166295', '322052579', '27/02/1944', 'Feminino', 'franciscajuliagoncalves@fernandesfilpi.com.br', '60356610', 'Travessa Boata', '100', 'Antônio Bezerra', 'Fortaleza', 'CE', '8537720094', '85988887344', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (10, 'Brenda Sebastiana Regina da Conceição', '9387021572', '499837794', '27/12/1949', 'Feminino', 'brendasebastianareginadaconceicao@solutionimoveis.com.br', '96506395', 'Rua Bruno Reinaldo Kipper', '456', 'Nossa Senhora de Fátima', 'Cachoeira do Sul', 'RS', '5137389592', '51988887387', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (11, 'Sophia Tatiane Lopes', '2023823110', '222874235', '26/12/1997', 'Feminino', 'STL@yahool.com.br', '79104460', 'Rua 66', '205', 'Vila Nova Campo Grande', 'Campo Grande', 'MS', '6725963752', '67999550907', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (12, 'Marcelo de Lima', '21002949467', '495922705', '20/12/1996', 'Masculino', 'marceloolima@gabiaatelier.com.br', '68927393', 'Travessa L14 do Provedor', '691', 'Provedor', 'Santana', 'AP', '9635009775', '96996507201', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (13, 'Maitê Allana Galvão', '33898989640', '500757008', '19/11/2000', 'Feminino', 'mmaiteallanagalvao@pq.cnpq.br', '24716400', 'Rua Sampaio Rodrigues', '487', 'Jardim Catarina', 'São Gonçalo', 'RJ', '2125071076', '21998339757', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (14, 'Patricia Nina Antônia Teixeira', '60294169873', '247838664', '5/11/1977', 'Feminino', 'patricianinaantoniateixeira@jonasmartinez.com', '68902017', 'Rua Três', '619', 'Beirol', 'Macapá', 'AP', '9636264952', '96998152747', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (15, 'Jairo Amaral', '98765432189', '99999999', '12/9/2000', 'Masculino', 'jairo@email.com', '78731432', 'Rua Gv-22', '401', 'Setor Residencial Granville II', 'Rondonópolis', 'MT', '6637208818', '', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (16, 'Milene Barcellos', '12345678907', '97123467', '13/07/1975', 'Feminino', 'mbarcallos@gmail.com', '77403230', 'Rua 4', '123', 'Jardim Eldorado', 'Gurupi', 'TO', '6425431427', '63987241213', 'Ativo');
INSERT INTO `Biblioteca`.`usuarios` (`idusuarios`, `nome`, `cpf`, `rg`, `datanasc`, `sexo`, `email`, `cep`, `logradouro`, `num`, `bairro`, `cidade`, `uf`, `fone1`, `fone2`, `status`) VALUES (17, 'Clarice Damasceno', '16273849573', '234876987', '21/12/2005', 'Feminino', 'clarice@hotmail.com', '74713240', 'Rua Guaiaquil', '604', 'Jardim Novo Mundo', 'Goiânia', 'GO', '8534520094', '63982141213', 'Ativo');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`obras`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (1, 'Pelas Ruas de Calcutá', 1, 1990, 5, 'Português', 1, '764321');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (2, 'Devoted - Devoção', 1, 2000, 4, 'Português', 1, '4347421');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (3, 'Rápido e Devagar - Duas Formas de Pensar', 3, 2015, 8, 'Inglês', 3, '64732829');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (4, 'Xô, Bactéria! Tire Suas Dúvidas Com Dr. Bactéria', 10, 2019, 4, 'Português', 5, '236678678');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (5, 'P.s. - Eu Te Amo ', 4, 2010, 4, 'Português', 4, '12354321');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (6, 'O Que Esperar Quando Você Está Esperando', 3, 2000, 4, 'Português', 5, '67849098');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (7, 'As Melhores Frases Em Veja', 1, 2017, 4, 'Português', 7, '274532617');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (8, 'Bichos Monstruosos', 1, 2015, 12, 'Português', 6, '7644309');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (9, 'Casas Mal Assombradas', 1, 1995, 10, 'Português', 6, '98076534');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (10, 'Colapso', 12, 2005, 13, 'Português', 6, '3214667-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (11, 'Colapso', 12, 2005, 13, 'Inglês', 6, '3214667-2');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (12, 'Armas, germes e aço', 23, 2017, 13, 'Português', 6, '12323456-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (13, 'Memórias Póstumas de Brás Cubas', 1, 1881, 1, 'Português', 5, '8764321-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (14, 'Memórias Póstumas de Brás Cubas', 1, 1881, 1, 'Espanhol', 9, '8764321-2');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (15, 'Memórias Póstumas de Brás Cubas', 1, 1881, 12, 'Inglês', 5, '8764321-3');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (16, 'Dom Casmurro', 1, 1899, 1, 'Português', 5, '98764321-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (17, 'Dom Casmurro', 1, 1899, 12, 'Inglês', 5, '98764321-2');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (18, 'Dom Casmurro', 1, 1899, 1, 'Espanhol', 5, '98764321-3');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (19, 'Quincas Borba', 1, 1891, 5, 'Português', 5, '68764321-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (22, 'Sapiens: Uma breve história da humanidade', 1, 2018, 5, 'Português', 6, '123456-1');
INSERT INTO `Biblioteca`.`obras` (`idobras`, `tituloobra`, `numero_edicao`, `ano_edicao`, `editoras_ideditoras`, `idioma`, `areaconhecimento_idareaconhecimento`, `ISBN`) VALUES (23, 'Sapiens: Uma breve história da humanidade', 1, 2018, 5, 'Alemão', 6, '123456-2');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`autores`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (1, 'Roberto Martins Figueiredo', 'Brasil');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (2, 'Daniel Kahneman', 'Israel');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (3, 'Hilary Duff', 'Estados Unidos');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (4, 'Robson Pinheiro', 'Brasil');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (5, 'Cecelia Ahern', 'Irlanda');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (6, 'Arlene Eisenberg', 'Estados Unidos');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (7, 'Sandee Hathaway', 'Canadá');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (8, 'Heidi Murkoff', 'Estados Unidos');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (9, 'Julio Cesar de Barros', 'Brasil');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (10, 'Maria José Valero', 'Portugal');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (11, 'Jared Diamond', 'Estados Unidos');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (12, 'Monteiro Lobato', 'Brasil');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (13, 'Machado de Assis', 'Brasil');
INSERT INTO `Biblioteca`.`autores` (`idautores`, `nome`, `paisnascimento`) VALUES (14, 'Yuval Noah Harari', 'Israel');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`exeplarobras`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (1, 1, '764321', 1, 'disponível', '2020-02-05');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (2, 1, '764321', 2, 'disponível', '2020-02-06');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (3, 2, '4347421', 1, 'extraviado', '2020-02-07');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (4, 3, '64732829', 1, 'em manutenção', '2020-02-08');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (5, 3, '64732829', 2, 'disponível', '2020-02-09');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (6, 4, '236678678', 1, 'disponível', '2020-02-10');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (7, 5, '12354321', 1, 'disponível', '2020-02-11');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (8, 6, '67849098', 1, 'disponível', '2020-02-12');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (9, 7, '274532617', 1, 'disponível', '2020-02-13');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (10, 8, '7644309', 1, 'disponível', '2020-02-14');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (11, 9, '98076534', 1, 'disponível', '2020-02-15');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (12, 10, '3214667-1', 1, 'emprestado', '2020-02-16');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (13, 10, '3214667-1', 2, 'extraviado', '2020-02-17');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (14, 11, '3214667-2', 1, 'disponível', '2020-02-18');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (15, 11, '3214667-2', 2, 'disponível', '2020-02-19');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (16, 11, '3214667-2', 3, 'disponível', '2020-02-20');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (17, 12, '12323456-1', 1, 'disponível', '2020-02-21');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (18, 12, '12323456-1', 2, 'disponível', '2020-02-22');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (19, 13, '8764321-1', 1, 'disponível', '2020-02-23');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (20, 13, '8764321-1', 2, 'disponível', '2020-02-24');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (21, 13, '8764321-1', 3, 'disponível', '2020-02-25');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (22, 14, '8764321-2', 1, 'disponível', '2020-02-26');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (23, 14, '8764321-2', 2, 'em manutenção', '2020-02-27');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (24, 14, '8764321-2', 3, 'disponível', '2020-02-28');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (25, 15, '8764321-3', 1, 'disponível', '2020-02-29');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (26, 16, '98764321-1', 1, 'disponível', '2020-03-01');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (27, 16, '98764321-1', 2, 'disponível', '2020-03-02');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (28, 16, '98764321-1', 3, 'disponível', '2020-03-03');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (29, 17, '98764321-2', 1, 'em manutenção', '2020-03-04');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (30, 17, '98764321-2', 2, 'disponível', '2020-03-05');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (31, 18, '98764321-3', 1, 'disponível', '2020-03-06');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (32, 19, '68764321-1', 1, 'disponível', '2020-03-07');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (33, 22, '123456-1', 1, 'disponível', '2020-03-08');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (34, 22, '123456-1', 2, 'disponível', '2020-03-09');
INSERT INTO `Biblioteca`.`exeplarobras` (`idexeplarobras`, `obras_idobras`, `isbnexemplar`, `id_exemplar`, `situacaoexemplar`, `dtaquisicao`) VALUES (35, 23, '123456-2', 1, 'disponível', '2020-03-10');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`emprestimos`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (1, 19, 12, '2004-09-22', '2004-10-02', '2004-10-02', '12:14:23');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (2, 20, 14, '1998-03-23', '1998-04-02', '1998-04-02', '17:42:46');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (3, 21, 12, '1990-08-26', '1990-09-05', '1990-09-05', '10:02:07');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (4, 22, 8, '2018-11-27', '2018-12-07', '2018-12-07', '9:43:58');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (5, 23, 15, '1990-03-21', '1990-03-31', '1990-04-01', '16:08:10');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (6, 1, 12, '2009-01-14', '2009-01-24', '2009-01-24', '9:48:24');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (7, 25, 4, '2009-10-28', '2009-11-07', '2009-11-07', '16:31:50');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (8, 11, 3, '2002-02-21', '2002-03-03', '2002-03-03', '9:34:01');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (9, 5, 12, '2019-04-14', '2019-04-24', '2019-04-24', '11:13:45');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (10, 19, 11, '1994-10-26', '1994-11-05', '1994-11-05', '14:57:32');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (11, 4, 7, '2020-02-15', '2020-02-25', '2020-02-25', '9:16:38');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (12, 7, 12, '2017-04-08', '2017-04-18', '2017-04-18', '12:23:41');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (13, 19, 4, '1990-07-07', '1990-07-17', '1990-07-17', '9:03:01');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (14, 19, 1, '2006-10-08', '2006-10-18', '2006-10-18', '9:35:03');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (15, 12, 12, '2021-05-11', '2021-05-21', '', '');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (16, 13, 7, '1990-12-22', '1991-01-01', '1991-01-01', '8:35:41');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (17, 15, 6, '2010-05-09', '2010-05-19', '2010-05-19', '11:42:36');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (18, 8, 12, '1999-06-05', '1999-06-15', '1999-06-15', '10:41:00');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (19, 15, 5, '2004-03-26', '2004-04-05', '2004-04-05', '17:46:41');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (20, 19, 12, '2021-04-09', '2021-04-19', '2021-04-19', '16:00:31');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (21, 12, 6, '2021-05-03', '2021-05-13', '2021-05-17', '15:05:08');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (22, 25, 5, '1991-11-22', '1991-12-02', '1991-12-02', '8:24:31');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (23, 16, 1, '1994-12-22', '1995-01-01', '1995-01-01', '9:48:41');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (24, 19, 4, '2016-07-23', '2016-08-02', '2016-08-02', '10:00:34');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (25, 33, 8, '2004-04-28', '2004-05-08', '2004-05-08', '13:51:09');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (26, 8, 9, '1995-08-08', '1995-08-18', '1995-08-18', '16:11:16');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (27, 33, 9, '1992-08-20', '1992-08-30', '1992-08-30', '8:15:47');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (28, 27, 7, '2012-04-27', '2012-05-07', '2012-05-07', '12:50:38');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (29, 19, 8, '2021-03-14', '2021-03-24', '2021-03-24', '14:28:05');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (30, 34, 11, '1996-06-09', '1996-06-19', '1996-06-19', '15:22:56');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (31, 18, 15, '2006-09-16', '2006-09-26', '2006-09-26', '14:08:13');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (32, 6, 15, '2013-09-05', '2013-09-15', '2013-09-15', '12:45:43');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (33, 19, 17, '1991-06-21', '1991-07-01', '1991-07-01', '14:50:11');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (34, 3, 11, '1997-04-17', '1997-04-27', '1997-04-27', '17:59:59');
INSERT INTO `Biblioteca`.`emprestimos` (`idemprestimos`, `exeplarobras_idexeplarobras`, `usuarios_idusuarios`, `dt_emprestimo`, `dt_prev_devol`, `dt_devol`, `hr_devol`) VALUES (35, 5, 10, '2012-09-21', '2012-10-01', '2012-10-01', '8:55:46');

COMMIT;


-- -----------------------------------------------------
-- Data for table `Biblioteca`.`obras_has_autores`
-- -----------------------------------------------------
START TRANSACTION;
USE `Biblioteca`;
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (4, 1);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (3, 2);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (2, 3);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (1, 4);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (5, 5);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (6, 7);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (6, 8);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (7, 9);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (8, 10);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (10, 11);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (11, 11);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (12, 11);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (13, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (14, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (15, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (16, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (17, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (18, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (19, 13);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (22, 14);
INSERT INTO `Biblioteca`.`obras_has_autores` (`obras_idobras`, `autores_idautores`) VALUES (23, 14);

COMMIT;

