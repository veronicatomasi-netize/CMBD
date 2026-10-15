-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           8.4.3 - MySQL Community Server - GPL
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para producao
CREATE DATABASE IF NOT EXISTS `producao` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `producao`;

-- Copiando estrutura para tabela producao.clientes
CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cnpj_cpf` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numero` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cep` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `referencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.compras
CREATE TABLE IF NOT EXISTS `compras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_fornecedor` int DEFAULT NULL,
  `id_produto` int DEFAULT NULL,
  `quantidade` float NOT NULL,
  `codigo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_compra` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_fornecedor` (`id_fornecedor`),
  KEY `id_produto` (`id_fornecedor`)
) ENGINE=InnoDB AUTO_INCREMENT=602 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.fornecedores
CREATE TABLE IF NOT EXISTS `fornecedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cnpj_cpf` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rua` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `numero` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cep` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.pedidos
CREATE TABLE IF NOT EXISTS `pedidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `id_produto` int DEFAULT NULL,
  `num_ped` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantidade` float NOT NULL,
  `data_ped` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.produtos
CREATE TABLE IF NOT EXISTS `produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cod_barra` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nome` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `estoque` float NOT NULL,
  `valor` float NOT NULL,
  `data_fabricacao` datetime DEFAULT NULL,
  `data_validade` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para procedure producao.sp_atualizar_produto
DELIMITER //
CREATE PROCEDURE `sp_atualizar_produto`(
	IN `p_novo_cod_barras` VARCHAR(50),
	IN `p_novo_nome` VARCHAR(50),
	IN `p_nova_descricao` VARCHAR(50),
	IN `p_novo_estoque` INT,
	IN `p_novo_valor` DECIMAL(10,2),
	IN `p_nova_data_fabricacao` DATE,
	IN `p_nova_data_validade` DATE
)
BEGIN
    UPDATE produtos
    SET
        cod_barra = COALESCE(p_novo_cod_barras, cod_barra),
        nome = COALESCE(p_novo_nome, nome),
        descricao = COALESCE(p_nova_descricao, descricao),
        estoque = COALESCE(p_novo_estoque, estoque),
        valor = COALESCE(p_novo_valor, valor),
        data_fabricacao = COALESCE(p_nova_data_fabricacao, data_fabricacao),
        data_validade = COALESCE(p_nova_data_validade, data_validade)
    WHERE
        id = p_id;
END//
DELIMITER ;

-- Copiando estrutura para procedure producao.sp_compras_por_fornecedor
DELIMITER //
CREATE PROCEDURE `sp_compras_por_fornecedor`(
	IN `p_id_fornecedor` INT,
	IN `p_data_inicio` DATE,
	IN `p_data_fim` DATE
)
BEGIN 
	SELECT 
		c.codigo,
		p.nome AS produto,
		c.quantidade,
		c.data_compra,
		f.nome AS fornecedor
	FROM compras
	INNER JOIN fornecedor f ON f.id = c.id_fornecedor
	INNER JOIN produtos p ON p.id = c.id_produto
	WHERE c.id_fornecedor = p_id_fornecedor
	AND c.data_compra BETWEEN p_data_inicio AND p_data_fim;
END//
DELIMITER ;

-- Copiando estrutura para procedure producao.sp_registrar_compra
DELIMITER //
CREATE PROCEDURE `sp_registrar_compra`(
	IN `p_id_fornecedor` INT,
	IN `p_id_produto` INT,
	IN `p_quantidade` INT,
	IN `p_codigo` VARCHAR(50)
)
BEGIN
    INSERT INTO compras (
        id_fornecedor,
        id_produto,
        quantidade,
        codigo,
        data_compra
    )
    VALUES (
        p_id_fornecedor,
        p_id_produto,
        p_quantidade,
        p_codigo,
        NOW()
    );
END//
DELIMITER ;

-- Copiando estrutura para tabela producao.tmp_historico_clientes
CREATE TABLE IF NOT EXISTS `tmp_historico_clientes` (
  `id` int DEFAULT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cnpj_cpf` varchar(20) DEFAULT NULL,
  `rua` varchar(100) DEFAULT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cep` varchar(10) DEFAULT NULL,
  `referencia` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `data_cadastro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.tmp_historico_fornecedor
CREATE TABLE IF NOT EXISTS `tmp_historico_fornecedor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_fornecedor` int DEFAULT NULL,
  `nome_antigo` varchar(100) DEFAULT NULL,
  `cnpj_cpf_antigo` varchar(18) DEFAULT NULL,
  `rua_antiga` varchar(255) DEFAULT NULL,
  `numero_antigo` varchar(50) DEFAULT NULL,
  `bairro_antigo` varchar(100) DEFAULT NULL,
  `cep_antigo` varchar(10) DEFAULT NULL,
  `telefone_antigo` varchar(100) DEFAULT NULL,
  `data_alteracao` date DEFAULT NULL,
  `usuario_alteracao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela producao.tmp_historico_produtos
CREATE TABLE IF NOT EXISTS `tmp_historico_produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_produto` int DEFAULT NULL,
  `cod_barra_antigo` varchar(255) DEFAULT NULL,
  `nome_antigo` varchar(255) DEFAULT NULL,
  `descricao_antiga` varchar(255) DEFAULT NULL,
  `estoque_antigo` float DEFAULT NULL,
  `valor_antigo` float DEFAULT NULL,
  `data_fabricacao_antiga` datetime DEFAULT NULL,
  `data_validade_antiga` datetime DEFAULT NULL,
  `data_alteracao` datetime DEFAULT CURRENT_TIMESTAMP,
  `usuario_alteracao` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para view producao.view_compra_detalhada
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_compra_detalhada` (
	`id` INT NOT NULL,
	`fornecedor` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`produto` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`quantidade` FLOAT NOT NULL,
	`codigo` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`data_compra` DATETIME NULL,
	`valor` FLOAT NOT NULL,
	`valor_total` DOUBLE NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_consolidacao_de_compras_por_fornecedor
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_consolidacao_de_compras_por_fornecedor` (
	`id_fornecedor` INT NOT NULL,
	`fornecedor` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`total_compras` BIGINT NOT NULL,
	`total_produtos` DOUBLE NOT NULL,
	`valor_total_compras` DOUBLE NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_de_demanda_de_produtos
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_de_demanda_de_produtos` (
	`id_produto` INT NOT NULL,
	`produto` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`quantidade_solicitada` DOUBLE NOT NULL,
	`total_pedidos` BIGINT NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_fornecedores_com_mais_vendas
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_fornecedores_com_mais_vendas` (
	`fornecedor` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`total_vendas` BIGINT NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_pedidos_com_valor_maior_que_media
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_pedidos_com_valor_maior_que_media` (
	`pedido` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci',
	`valor_total` DOUBLE NOT NULL
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_produtos_mais_vendidos_no_ultimo_mes
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_produtos_mais_vendidos_no_ultimo_mes` (
	`produto` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`total_vendas` BIGINT NOT NULL,
	`data_ped` VARCHAR(1) NULL COLLATE 'utf8mb4_general_ci'
) ENGINE=MyISAM;

-- Copiando estrutura para view producao.view_valor_total_vendas_por_cliente
-- Criando tabela temporária para evitar erros de dependência de VIEW
CREATE TABLE `view_valor_total_vendas_por_cliente` (
	`cliente` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_general_ci',
	`valor_total` DOUBLE NULL
) ENGINE=MyISAM;

-- Copiando estrutura para trigger producao.trg_atualiza_estoque_compras
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trg_atualiza_estoque_compras` AFTER INSERT ON `compras` FOR EACH ROW BEGIN
	UPDATE produtos
	SET estoque = estoque + NEW.quantidade
	WHERE id = NEW.id_produto;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger producao.trg_atualiza_estoque_pedidos
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trg_atualiza_estoque_pedidos` AFTER INSERT ON `pedidos` FOR EACH ROW BEGIN
	UPDATE produtos
	SET estoque = estoque - NEW.quantidade
	WHERE id = NEW.id_produto;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Copiando estrutura para trigger producao.trg_atualiza_produtos
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `trg_atualiza_produtos` BEFORE UPDATE ON `produtos` FOR EACH ROW BEGIN
    INSERT INTO tmp_historico_produtos (
        produto_id,
        nome_antigo,
        preco_antigo,
        estoque_antigo,
        usuario_alteracao
    )
    VALUES (
        OLD.id,
        OLD.nome,
        OLD.valor,
        OLD.estoque,
        USER()
    );
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_compra_detalhada`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_compra_detalhada` AS select `compras`.`id` AS `id`,`fornecedores`.`nome` AS `fornecedor`,`produtos`.`nome` AS `produto`,`compras`.`quantidade` AS `quantidade`,`compras`.`codigo` AS `codigo`,`compras`.`data_compra` AS `data_compra`,`produtos`.`valor` AS `valor`,(`compras`.`quantidade` * `produtos`.`valor`) AS `valor_total` from ((`compras` join `fornecedores` on((`compras`.`id_fornecedor` = `fornecedores`.`id`))) join `produtos` on((`compras`.`id_produto` = `produtos`.`id`)));

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_consolidacao_de_compras_por_fornecedor`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_consolidacao_de_compras_por_fornecedor` AS select `fornecedores`.`id` AS `id_fornecedor`,`fornecedores`.`nome` AS `fornecedor`,count(`compras`.`id`) AS `total_compras`,coalesce(sum(`compras`.`quantidade`),0) AS `total_produtos`,coalesce(sum((`compras`.`quantidade` * `produtos`.`valor`)),0) AS `valor_total_compras` from ((`fornecedores` left join `compras` on((`fornecedores`.`id` = `compras`.`id_fornecedor`))) left join `produtos` on((`compras`.`id_produto` = `produtos`.`id`))) group by `fornecedores`.`id`,`fornecedores`.`nome`;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_de_demanda_de_produtos`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_de_demanda_de_produtos` AS select `produtos`.`id` AS `id_produto`,`produtos`.`nome` AS `produto`,coalesce(sum(`pedidos`.`quantidade`),0) AS `quantidade_solicitada`,count(`pedidos`.`id`) AS `total_pedidos` from (`produtos` left join `pedidos` on((`produtos`.`id` = `pedidos`.`id_produto`))) group by `produtos`.`id`,`produtos`.`nome`;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_fornecedores_com_mais_vendas`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_fornecedores_com_mais_vendas` AS select `f`.`nome` AS `fornecedor`,count(`c`.`id`) AS `total_vendas` from (`compras` `c` join `fornecedores` `f` on((`c`.`id_fornecedor` = `f`.`id`))) group by `f`.`id` order by count(`c`.`id`) desc;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_pedidos_com_valor_maior_que_media`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_pedidos_com_valor_maior_que_media` AS select `p`.`num_ped` AS `pedido`,round((`p`.`quantidade` * `pro`.`valor`),2) AS `valor_total` from (`pedidos` `p` join `produtos` `pro` on((`p`.`id_produto` = `pro`.`id`))) where ((`p`.`quantidade` * `pro`.`valor`) > (select avg((`p2`.`quantidade` * `pro2`.`valor`)) AS `media` from (`pedidos` `p2` join `produtos` `pro2` on((`p2`.`id_produto` = `pro2`.`id`))))) order by round((`p`.`quantidade` * `pro`.`valor`),2) desc;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_produtos_mais_vendidos_no_ultimo_mes`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_produtos_mais_vendidos_no_ultimo_mes` AS select `pro`.`nome` AS `produto`,count(`p`.`id`) AS `total_vendas`,date_format(`p`.`data_ped`,'%m/%Y') AS `data_ped` from (`pedidos` `p` join `produtos` `pro` on((`p`.`id_produto` = `pro`.`id`))) where ((year(`p`.`data_ped`) = year(now())) and (month(`p`.`data_ped`) = (month(now()) - 1))) group by `pro`.`id` order by count(`p`.`id`) desc;

-- Removendo tabela temporária e criando a estrutura VIEW final
DROP TABLE IF EXISTS `view_valor_total_vendas_por_cliente`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_valor_total_vendas_por_cliente` AS select `cli`.`nome` AS `cliente`,round(sum((`p`.`quantidade` * `pro`.`valor`)),2) AS `valor_total` from ((`pedidos` `p` join `clientes` `cli` on((`p`.`id_cliente` = `cli`.`id`))) join `produtos` `pro` on((`p`.`id_produto` = `pro`.`id`))) group by `cli`.`id` order by round(sum((`p`.`quantidade` * `pro`.`valor`)),2) desc;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
