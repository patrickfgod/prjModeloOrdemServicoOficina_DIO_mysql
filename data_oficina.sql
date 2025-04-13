INSERT INTO cliente (nome, telefone, email, endereco) VALUES
('João Silva', '123456789', 'joao.silva@example.com', 'Rua A, 123'),
('Maria Santos', '987654321', 'maria.santos@example.com', 'Rua B, 456'),
('Pedro Oliveira', '555555555', 'pedro.oliveira@example.com', 'Rua C, 789'),
('Ana Lima', '111111111', 'ana.lima@example.com', 'Rua D, 101'),
('Carlos Martins', '222222222', 'carlos.martins@example.com', 'Rua E, 202');

INSERT INTO veiculo (placa, modelo, marca, ano, idCliente) VALUES
('ABC1234', 'Gol', 'Volkswagen', 2015, 1),
('DEF5678', 'Civic', 'Honda', 2018, 2),
('GHI9012', 'Corolla', 'Toyota', 2020, 3),
('JKL3456', 'Fusion', 'Ford', 2012, 4),
('MNO7890', 'Cruze', 'Chevrolet', 2016, 5);

INSERT INTO ordem_servico (dataAbertura, dataFechamento, status, descricao, idVeiculo) VALUES
('2023-01-01', '2023-01-15', 'Concluída', 'Troca de óleo e filtros', 1),
('2023-02-01', NULL, 'Em andamento', 'Revisão completa', 2),
('2023-03-01', '2023-03-10', 'Concluída', 'Troca de pneus', 3),
('2023-04-01', NULL, 'Aberta', 'Reparo de freios', 4),
('2023-05-01', '2023-05-20', 'Concluída', 'Revisão de suspensão', 5);

INSERT INTO servico (nome, descricao, preco) VALUES
('Troca de óleo', 'Troca de óleo sintético', 100.00),
('Revisão completa', 'Verificação de todos os sistemas do veículo', 500.00),
('Troca de pneus', 'Troca de quatro pneus novos', 800.00),
('Reparo de freios', 'Reparo ou troca de pastilhas e discos de freio', 300.00),
('Revisão de suspensão', 'Verificação e ajuste da suspensão', 200.00);

INSERT INTO servico_ordem (idOrdem, idServico, quantidade) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1);

INSERT INTO peca (nome, descricao, preco) VALUES
('Óleo sintético', 'Óleo para motores a gasolina', 50.00),
('Pneu', 'Pneu para veículos leves', 200.00),
('Pastilha de freio', 'Pastilha de freio para veículos leves', 20.00),
('Filtro de ar', 'Filtro de ar para motores a gasolina', 15.00),
('Amortecedor', 'Amortecedor para suspensão de veículos leves', 100.00);

INSERT INTO peca_ordem (idOrdem, idPeca, quantidade) VALUES
(1, 1, 4),
(2, 4, 1),
(3, 2, 4),
(4, 3, 4),
(5, 5, 2);


INSERT INTO fornecedor (nome, cnpj, telefone, email) VALUES
('Fornecedor A', '12345678000191', '123456789', 'fornecedorA@example.com'),
('Fornecedor B', '98765432000192', '987654321', 'fornecedorB@example.com'),
('Fornecedor C', '55555555000193', '555555555', 'fornecedorC@example.com'),
('Fornecedor D', '11111111000194', '111111111', 'fornecedorD@example.com'),
('Fornecedor E', '22222222000195', '222222222', 'fornecedorE@example.com');

INSERT INTO pagamento (idOrdem, valor, dataPagamento, status) VALUES
(1, 150.00, '2023-01-15 10:00:00', 'Pago'),
(2, 550.00, NULL, 'Pendente'),
(3, 1000.00, '2023-03-10 12:00:00', 'Pago'),
(4, 350.00, NULL, 'Pendente'),
(5, 250.00, '2023-05-20 14:00:00', 'Pago');

INSERT INTO pagamento_cartao (idPagamento, numeroCartao, tipoCartao, nomeTitular) VALUES
(1, '1234567890123456', 'Crédito', 'João Silva'),
(3, '9876543210987654', 'Débito', 'Maria Santos'),
(5, '5555555555555555', 'Crédito', 'Pedro Oliveira');

INSERT INTO pagamento_boleto (idPagamento, numeroBoleto, dataVencimento) VALUES
(2, '12345678901234567890', '2023-03-01'),
(4, '98765432109876543210', '2023-05-01');

INSERT INTO pagamento_pix (idPagamento, chavePix) VALUES
(1, 'joao.silva@example.com'),
(3, 'maria.santos@example.com'),
(5, 'pedro.oliveira@example.com');


--número total de registros na tabela cliente
SELECT COUNT(*) FROM cliente;

--ordenação com ORDER BY
SELECT * FROM cliente ORDER BY nome;

--filtro com WHERE
SELECT * FROM ordem_servico WHERE dataFechamento > '2023-01-01';

--filtro de grupo com HAVING
SELECT 
    c.idCliente, 
    c.nome, 
    COUNT(v.idVeiculo) AS TotalVeiculos
FROM cliente c
JOIN veiculo v ON c.idCliente = v.idCliente
GROUP BY c.idCliente, c.nome
HAVING COUNT(v.idVeiculo) > 1;

--numero de quantos veiculos tem cada cliente
SELECT 
    c.idCliente, 
    c.nome, 
    COUNT(v.idVeiculo) AS TotalVeiculos
FROM cliente c
JOIN veiculo v ON c.idCliente = v.idCliente
GROUP BY c.idCliente, c.nome;

--numero de ordem de servico por veiculo
SELECT 
    v.idVeiculo, 
    v.placa, 
    COUNT(os.idOrdem) AS TotalOrdens
FROM veiculo v
JOIN ordem_servico os ON v.idVeiculo = os.idVeiculo
GROUP BY v.idVeiculo, v.placa;

--valor total dos serviços por ordem de serviço
SELECT 
    os.idOrdem, 
    SUM(so.quantidade * s.preco) AS ValorTotalServicos
FROM ordem_servico os
JOIN servico_ordem so ON os.idOrdem = so.idOrdem
JOIN servico s ON so.idServico = s.idServico
GROUP BY os.idOrdem;

--valor total dos pagamentos por ordem de serviço
SELECT 
    os.idOrdem, 
    SUM(p.valor) AS ValorTotalPagamentos
FROM ordem_servico os
JOIN pagamento p ON os.idOrdem = p.idOrdem
GROUP BY os.idOrdem;

--tipos de pagamento utilizados
SELECT 
    CASE 
        WHEN pc.idPagamentoCartao IS NOT NULL THEN 'Cartão'
        WHEN pb.idPagamentoBoleto IS NOT NULL THEN 'Boleto'
        WHEN pix.idPagamentoPix IS NOT NULL THEN 'Pix'
        ELSE 'Outro'
    END AS TipoPagamento,
    COUNT(*) AS Quantidade
FROM pagamento p
LEFT JOIN pagamento_cartao pc ON p.idPagamento = pc.idPagamento
LEFT JOIN pagamento_boleto pb ON p.idPagamento = pb.idPagamento
LEFT JOIN pagamento_pix pix ON p.idPagamento = pix.idPagamento
GROUP BY 
    CASE 
        WHEN pc.idPagamentoCartao IS NOT NULL THEN 'Cartão'
        WHEN pb.idPagamentoBoleto IS NOT NULL THEN 'Boleto'
        WHEN pix.idPagamentoPix IS NOT NULL THEN 'Pix'
        ELSE 'Outro'
    END;

--Quais são os pagamentos pendentes com valor superior a R$ 500,00?
SELECT * FROM pagamento WHERE status = 'Pendente' AND valor > 500.00;
