-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS oficina_mecanica;
USE oficina_mecanica;

CREATE TABLE cliente (
    idCliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    endereco VARCHAR(255)
);

CREATE TABLE veiculo (
    idVeiculo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(8) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    idCliente INT NOT NULL,
    
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);

CREATE TABLE ordem_servico (
    idOrdem INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    dataAbertura DATE NOT NULL DEFAULT CURRENT_DATE,
    dataFechamento DATE,
    status ENUM('Aberta', 'Em andamento', 'Concluída', 'Cancelada') NOT NULL DEFAULT 'Aberta',
    descricao TEXT,
    idVeiculo INT NOT NULL,
    
    CONSTRAINT fk_ordem_servico_veiculo FOREIGN KEY (idVeiculo) REFERENCES veiculo(idVeiculo)
);

CREATE TABLE servico (
    idServico INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco FLOAT NOT NULL
);

CREATE TABLE servico_ordem (
    idServicoOrdem INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idOrdem INT NOT NULL,
    idServico INT NOT NULL,
    quantidade INT DEFAULT 1,
    
    CONSTRAINT fk_servico_ordem_ordem FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem),
    CONSTRAINT fk_servico_ordem_servico FOREIGN KEY (idServico) REFERENCES servico(idServico)
);

CREATE TABLE peca (
    idPeca INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco FLOAT NOT NULL
);

CREATE TABLE peca_ordem (
    idPecaOrdem INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idOrdem INT NOT NULL,
    idPeca INT NOT NULL,
    quantidade INT DEFAULT 1,
    
    CONSTRAINT fk_peca_ordem_ordem FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem),
    CONSTRAINT fk_peca_ordem_peca FOREIGN KEY (idPeca) REFERENCES peca(idPeca)
);

CREATE TABLE fornecedor (
    idFornecedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(14) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100),
    
    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj)
);

CREATE TABLE pagamento (
    idPagamento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idOrdem INT NOT NULL,
    valor FLOAT NOT NULL,
    dataPagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Pago', 'Cancelado') NOT NULL DEFAULT 'Pendente',
    
    CONSTRAINT fk_pagamento_ordem FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem)
);

CREATE TABLE pagamento_cartao (
    idPagamentoCartao INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idPagamento INT NOT NULL,
    numeroCartao VARCHAR(20) NOT NULL,
    tipoCartao ENUM('Crédito', 'Débito') NOT NULL,
    nomeTitular VARCHAR(100) NOT NULL,
    
    CONSTRAINT fk_pagamento_cartao_pagamento FOREIGN KEY (idPagamento) REFERENCES pagamento(idPagamento)
);

CREATE TABLE pagamento_boleto (
    idPagamentoBoleto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idPagamento INT NOT NULL,
    numeroBoleto VARCHAR(50) NOT NULL,
    dataVencimento DATE NOT NULL,
    
    CONSTRAINT fk_pagamento_boleto_pagamento FOREIGN KEY (idPagamento) REFERENCES pagamento(idPagamento)
);

CREATE TABLE pagamento_pix (
    idPagamentoPix INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idPagamento INT NOT NULL,
    chavePix VARCHAR(50) NOT NULL,
    
    CONSTRAINT fk_pagamento_pix_pagamento FOREIGN KEY (idPagamento) REFERENCES pagamento(idPagamento)
);
