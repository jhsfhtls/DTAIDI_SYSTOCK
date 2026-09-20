CREATE DATABASE INVENTORY_SUPPLY_CHAIN;

USE DATABASE INVENTORY_SUPPLY_CHAIN;

--CRIAÇÃO DAS TABELAS 
--venda
CREATE TABLE public.venda(
	venda_id int8 NOT NULL,
	data_emissao date NOT NULL,
	horariomov varchar(8) DEFAULT '00:00:00'::character varying NOT NULL,
	produto_id varchar(25) DEFAULT ''::character varying NOT NULL,
	qtde_vendida float8 NULL,
	valor_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
	filial_id int8 DEFAULT 1 NOT NULL,
	item int4 DEFAULT 0 NOT NULL,
	unidade_medida varchar(3) NULL,
	CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov)
);

--pedido_compra
CREATE TABLE public.pedido_compra(
	pedido_id float8 DEFAULT 0 NOT NULL,
	data_pedido date NULL,
	item float8 DEFAULT 0 NOT NULL,
	produto_id varchar(25) DEFAULT '0' NOT NULL,
	descricao_produto varchar(255) NULL,
	ordem_compra float8 DEFAULT 0 NOT NULL,
	qtde_pedida float8 NULL,
	filial_id int4 NULL,
	data_entrega date NULL,
	qtde_entregue float8 DEFAULT 0 NOT NULL,
	qtde_pendente float8 DEFAULT 0 NOT NULL,
	preco_compra float8 DEFAULT 0 NULL,
	fornecedor_id int4 DEFAULT 0 NULL,
	CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id , produto_id, item)
);

--entradas_mercadoria
CREATE TABLE public.entradas_mercadoria (
	data_entrada date NULL,
	nro_nfe varchar(255) NOT NULL,
	item float8 DEFAULT 0 NOT NULL,
	produto_id varchar(25) DEFAULT '0' NOT NULL,
	descricao_produto varchar(255) NULL,
	qtde_recebida float8 NULL,
	filial_id int4 NULL,
	custo_unitario numeric(12, 4) DEFAULT 0 NOT NULL,
	CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (/*ordem_compra,*/ item, produto_id, nro_nfe)
);

-- Parte 1 – Consultas SQL Básicas**
--1.1 – Consumo por produto e mês**
-- 	Monte uma consulta que traga o total de consumo de cada produto no mês de fevereiro de 2025. 

SELECT
	produto_id,
	count(venda_id) AS "QTDE_VENDAS_TOTAL",
	SUM(qtde_vendida) AS "QTDE_VENDIDA_TOTAL",
	SUM(valor_unitario) AS "VALOR_UNITARIO_TOTAL",
	SUM(valor_unitario * qtde_vendida) as "VALOR_TOTAL_VENDIDO"
FROM
	venda
WHERE
	EXTRACT(year from data_emissao) = 2025
	AND EXTRACT(month from data_emissao) = 2
GROUP BY
	produto_id

-- 1.2 – Produtos com requisição pendente
--Crie uma consulta para listar os produtos que foram requisitados, mas não recebidos.

SELECT
	produto_id,
	data_pedido,
	qtde_pedida,
	qtde_entregue
FROM
	pedido_compra
where
	(data_pedido is not null and qtde_pedida is not null)
	and (qtde_entregue is null or qtde_entregue <> 0 )
	

--1.3 – Produtos não consumidos e não recebidos
-- Monte uma consulta para listar produtos que foram requisitados, mas não consumidos e não recebidos, no mês de fevereiro de 2025.
select
	*
from
	entradas_mercadoria
where
	EXTRACT(year from data_entrada) = 2025
	AND EXTRACT(month from data_entrada) = 2	
	AND (data_entrada is not null) and qtde_recebida is null
	
	
--Parte 2 – Transformações de Dados
--Crie uma consulta SQL com os seguintes requisitos para as pedidos de compra e vendas:
--Concatenar os campos produto_id e descricao_produto (onde houver) no formato;
--Retornar os dados filtrando apenas os produtos requisitados mais de 10 vezes no período.
	
select
	CONCAT(pedido_id,' - ', descricao_produto ) as "CHAVE_PRODUTO",
	SUM(qtde_pedida) as "QTDE_REQUISITADA",
	to_char(pc.data_pedido, 'DD/MM/YYYY') as "DATA_SOLICITACAO"
from
	pedido_compra pc
WHERE
	EXTRACT(year from data_pedido) = 2025
	AND EXTRACT(month from data_pedido) = 2
group by
	pedido_id, descricao_produto, data_pedido
having sum(qtde_pedida) >10

--Parte 3 – Estratégia de Validação com o Cliente
--Imagine que você precisa validar os dados do mês de Fevereiro de 2025 com o cliente.

--Quais seriam os principais pontos que você validaria com o cliente?
--Eu começaria validando a intregridade dos dados fornecidos, durante todo o processo de ETL, garantindo que a informação que estivéssemos trazendo nas consultas fosse condizente com a realidade do mesmo.

--Quais técnicas utilizaria para garantir a exatidão e a precisão dos dados?
--Faria consultas para identificar campos nulos, verificaria a tipagem de cada coluna, e revisaria todo o processo de construção ETL

--Quais consultas você deixaria prontas para usar na reunião de validação?
--Deixaria pronto queries que mostrassem quantos campos tem em branco em cada coluna;
--Uma querie de gerenciamento de vendas, pedidos, requisições,
--Deixaria pronto queries com os produtos cadastrados e suas respectivas vendas por períodos.


