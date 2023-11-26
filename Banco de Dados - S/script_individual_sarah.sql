
DROP DATABASE IF EXISTS PowerTechSolutions;

CREATE DATABASE IF NOT EXISTS PowerTechSolutions;

USE PowerTechSolutions;

-- Criação das tabelas 

CREATE TABLE IF NOT EXISTS Grupo_Empresa(
	IDGrupo_Empresa INT PRIMARY KEY AUTO_INCREMENT,
    Apelido_Interno_Grupo VARCHAR(100),
    Razao_social VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Unidade_de_negocio(
	IDUnidade INT PRIMARY KEY AUTO_INCREMENT,
    Cnpj CHAR(14),
    Apelido_interno VARCHAR(100),
	Nome_Fantasia VARCHAR(100),
    FKGrupo_empresa INT,
		CONSTRAINT FKGrupo_Com_Unidade FOREIGN KEY (FKGrupo_empresa)
			REFERENCES Grupo_Empresa(IDGrupo_Empresa)
);

CREATE TABLE IF NOT EXISTS Endereco_Unidade(
	IDEndereco_unidade INT PRIMARY KEY AUTO_INCREMENT,
    Cep VARCHAR(8),
    Logradouro VARCHAR(100),
    Bairro VARCHAR(100),
    Localidade VARCHAR(100),
    UF CHAR(2),
    FKUnidade_negocio INT,
		CONSTRAINT FKUnidade_Endereco FOREIGN KEY (FKUnidade_negocio)
			REFERENCES Unidade_de_negocio(IDUnidade)
);

CREATE TABLE IF NOT EXISTS Permissoes(
	IDPermissao INT PRIMARY KEY AUTO_INCREMENT,
    Visualizar TINYINT,
    Editar TINYINT,
    Cadastrar TINYINT,
    Deletar TINYINT
);

CREATE TABLE IF NOT EXISTS Nivel_acesso(
	IDNivel_acesso INT AUTO_INCREMENT,
    Apelido VARCHAR(60),
	FKPermissao INT,
		CONSTRAINT FKNivel_Permissao FOREIGN KEY (FKPermissao)
			REFERENCES Permissoes(IDPermissao),
		CONSTRAINT PKNivel_permissao PRIMARY KEY (IDNivel_acesso,FKPermissao)
);

CREATE TABLE IF NOT EXISTS Usuario_Dashboard(
	IDUsuario INT AUTO_INCREMENT,
	Nome VARCHAR(150),
    Email VARCHAR(150),
    Cpf CHAR(11),
    Senha CHAR(8),
    FKUnidade INT,
    FKNivel_acesso INT,
		CONSTRAINT FKUnidade_Usuario FOREIGN KEY (FKUnidade)
			REFERENCES Unidade_de_negocio(IDUnidade),
		CONSTRAINT FKNivel_Usuario FOREIGN KEY (FKNivel_acesso)
			REFERENCES Nivel_acesso(IDNivel_acesso),
		CONSTRAINT PKUsuario_Nivel_acesso PRIMARY KEY (IDUsuario,FKNivel_acesso)
);

select * from Usuario_Dashboard;

CREATE TABLE IF NOT EXISTS Feedbacks(
	IDFeedback INT PRIMARY KEY AUTO_INCREMENT,
    Feedbacks VARCHAR(250),
    Estrelas INT,
		CHECK (Estrelas < 5 AND Estrelas > 0),
	FKUsuario INT,
		CONSTRAINT FKUsuario_Feedback FOREIGN KEY (FKUsuario)
			REFERENCES Usuario_Dashboard(IDUsuario)
);

CREATE TABLE IF NOT EXISTS Maquinas(
	IDMaquina INT PRIMARY KEY AUTO_INCREMENT,
    Apelido VARCHAR(100),
    FKFuncionario INT,
		CONSTRAINT FKFuncionario_maquina_fisica FOREIGN KEY (FKFuncionario)
			REFERENCES Usuario_Dashboard(IDUsuario)
);

select * from Maquinas;

CREATE TABLE IF NOT EXISTS Redes_conectadas(
	IDConexao INT PRIMARY KEY AUTO_INCREMENT,
    Data_Hora_Conexao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Servidor_DNS VARCHAR(45),
    FKMaquina INT,
		CONSTRAINT FKMaquina_Rede FOREIGN KEY (FKMaquina)
			REFERENCES Maquinas(IDMaquina)
);

CREATE TABLE IF NOT EXISTS Janelas_Abertas(
	IDRegistro INT PRIMARY KEY AUTO_INCREMENT,
    IDJanela INT,
    PIDJanelas INT,
    Nome_Janelas VARCHAR(500),
	Data_Hora_Conexao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FKMaquina INT,
		CONSTRAINT FKMaquina_Janelas FOREIGN KEY (FKMaquina)
			REFERENCES Maquinas(IDMaquina)
);

CREATE TABLE IF NOT EXISTS Dispositivos_USB(
	IDRegistro INT PRIMARY KEY AUTO_INCREMENT,
    Nome_Dispositivo VARCHAR(300),
    Data_Hora_Conexao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FKMaquina INT,
		CONSTRAINT FKMaquina_Usb FOREIGN KEY (FKMaquina)
			REFERENCES Maquinas(IDMaquina)
);

CREATE TABLE IF NOT EXISTS Tipo_maquina(
	IDTipo INT PRIMARY KEY AUTO_INCREMENT,
    Apelido VARCHAR(80)
);

insert into Tipo_Maquina values
(1, "virtual"),
(2, "física");


CREATE TABLE IF NOT EXISTS Componentes_maquina(
	IDComponente INT PRIMARY KEY AUTO_INCREMENT,
    Apelido VARCHAR(100),
    FKMaquina INT,
		CONSTRAINT FKMaquina_Componente FOREIGN KEY (FKMaquina)
			REFERENCES Maquinas(IDMaquina)
);

CREATE TABLE IF NOT EXISTS Parametros_componente(
	IDParametro INT PRIMARY KEY AUTO_INCREMENT,
    Parametro DOUBLE,
    FKComponente INT,
		CONSTRAINT FKComponente_Parametro FOREIGN KEY (FKComponente)
			REFERENCES Componentes_maquina(IDComponente)
);

CREATE TABLE IF NOT EXISTS Componentes_cadastrados(
	IDComponente_cadastrado INT PRIMARY KEY AUTO_INCREMENT,
    Apelido VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS Componentes_monitorados(
	IDComponente_monitorado INT AUTO_INCREMENT,
    FKComponente_cadastrado INT,
    FKMaquina INT,
		CONSTRAINT FKCompoenente_C_Componente_M FOREIGN KEY (FKComponente_cadastrado)
			REFERENCES Componentes_cadastrados(IDComponente_cadastrado),
		CONSTRAINT FKMaquina_Componente_M FOREIGN KEY (FKMaquina)
			REFERENCES Maquinas(IDMaquina),
		CONSTRAINT PKComponente_C_Componente_M PRIMARY KEY (IDComponente_monitorado,FKComponente_cadastrado)
);

CREATE TABLE IF NOT EXISTS Monitoramento_RAW(
	IDMonitoramento INT PRIMARY KEY AUTO_INCREMENT,
    Data_Hora_Captura DATETIME DEFAULT CURRENT_TIMESTAMP,
    Dado_Capturado VARCHAR(30),
    FKComponente_Monitorado INT,
		CONSTRAINT FKMonitoramento_RAW_Componente_maquina FOREIGN KEY (FKComponente_Monitorado)
			REFERENCES Componentes_monitorados(IDComponente_monitorado)
);

select * from Monitoramento_RAW; 


CREATE TABLE IF NOT EXISTS Monitoramento_Trusted(
	IDMonitoramento INT PRIMARY KEY,
    Data_Hora_Captura DATETIME DEFAULT CURRENT_TIMESTAMP,
    Dado_Capturado VARCHAR(30),
    FKComponente_Monitorado INT,
    CONSTRAINT FKMonitoramento_TRUSTED_Componente_maquina FOREIGN KEY (FKComponente_Monitorado)
			REFERENCES Componentes_monitorados(IDComponente_monitorado)
);

CREATE TABLE IF NOT EXISTS Nivel_alerta(
	IDNivel_alerta INT PRIMARY KEY AUTO_INCREMENT,
    Nivel VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS Alertas(
	IDAlerta INT PRIMARY KEY AUTO_INCREMENT,
    Alerta VARCHAR(100),
    Data_Hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FKMonitoramento INT,
    FKNivel_alerta INT,
    FKUnidade_negocio INT,
		CONSTRAINT FKMonitoramento_alerta FOREIGN KEY (FKMonitoramento)
			REFERENCES Monitoramento_Trusted(IDMonitoramento),
		CONSTRAINT FKNivel_alerta FOREIGN KEY (FKNivel_alerta)
			REFERENCES Nivel_alerta(IDNivel_alerta),
		CONSTRAINT FKUnidade_negocio_alerta FOREIGN KEY (FKUnidade_negocio)
			REFERENCES Unidade_de_negocio(IDUnidade)
);


-- inicio script individual sarah

CREATE TABLE IF NOT EXISTS Processos(
IDProcesso INT AUTO_INCREMENT,
PID INT,
nomeProcesso VARCHAR(255),
uso_cpu FLOAT,
uso_ram FLOAT,
data_hora DATETIME,
fkMaquina INT,
    CONSTRAINT fkMaquina FOREIGN KEY (fkMaquina)
        REFERENCES Maquinas(idMaquina),
constraint pkCompostaP primary key (IDProcesso, fkMaquina)
);

-- criando um trigger da tabela processos

DELIMITER $$

CREATE TRIGGER Criar_Alerta_Processo 
    AFTER INSERT ON Processos
FOR EACH ROW
BEGIN 

    IF NEW.uso_cpu >= 13.2 THEN 
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 3, "cpu", NEW.IDProcesso, NEW.fkMaquina);
    ELSEIF NEW.uso_cpu >= 7.2 THEN 
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 2, "cpu", NEW.IDProcesso, NEW.fkMaquina);
    ELSEIF NEW.uso_cpu <= 7.0 THEN
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 1, "cpu", NEW.IDProcesso, NEW.fkMaquina);
    END IF;

    IF NEW.uso_ram >= 11.2 THEN 
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 3, "ram", NEW.IDProcesso, NEW.fkMaquina);
    ELSEIF NEW.uso_ram >= 6.2 THEN 
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 2, "ram", NEW.IDProcesso, NEW.fkMaquina);
    ELSEIF NEW.uso_ram <= 3.5 THEN
        INSERT INTO Alerta_Processos (PID, nomeProcesso, uso_cpu, uso_ram, data_hora, tipo_alerta, fkProcesso, fkMaquina) 
        VALUES (NEW.PID, NEW.nomeProcesso, NEW.uso_cpu, NEW.uso_ram, now(), 1, "ram", NEW.IDProcesso, NEW.fkMaquina);
    END IF;

END;
$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS Alerta_Processo(
IDAlertaProcessos INT AUTO_INCREMENT,
PID INT,
nomeProcesso VARCHAR(255),
uso_cpu FLOAT,
uso_ram FLOAT,
data_hora DATETIME,
tipo_alerta int,
FKProcesso INT,
	CONSTRAINT fkProcesso FOREIGN KEY (fkProcesso)
        REFERENCES Processos(idProcesso),
fkMaquina INT,
    CONSTRAINT fkMaquinaP FOREIGN KEY (fkMaquina)
        REFERENCES Maquinas(idMaquina),
constraint pkCompostaA primary key (IDAlertaProcessos, fkProcesso, fkMaquina)
);

CREATE TABLE IF NOT EXISTS Processos_Encerrados(
IDProcessos_Encerrados INT AUTO_INCREMENT,
data_hora DATETIME,
FKAlertaProcessos INT,
	CONSTRAINT fkAlertaProcessos FOREIGN KEY (fkAlertaProcessos)
        REFERENCES Alerta_Processo(idAlertaProcessos),
FKProcesso INT,
	CONSTRAINT fkProcessoA FOREIGN KEY (fkProcesso)
        REFERENCES Processos(idProcesso),
fkMaquina INT,
    CONSTRAINT fkMaquinaPA FOREIGN KEY (fkMaquina)
        REFERENCES Maquinas(idMaquina),
constraint pkCompostaA primary key (IDProcessos_Encerrados, fkAlertaProcessos, fkProcesso, fkMaquina)
);

-- Aréa de inserts para testes de funcionalidade grupo

INSERT INTO Grupo_Empresa VALUES
(null,'EDP Smart','EDP ENERGIAS DO BRASIL S.A.'),
(null,'Matrix','Matrix Comercio e Servicos LTDA'),
(null,'AES Tietê','AES TIETE INTEGRA SOLUCOES EM ENERGIA LTDA.');

INSERT INTO Unidade_de_negocio VALUES
(null,'28630316000186','EDP Smart Sede','EDP Energias do Brasil',1),
(null,'28630316000286','EDP Smart Faria Lima','EDP Energias do Brasil',1),
(null,'28630316000386','EDP Smart Suzano','EDP Energias do Brasil',1),
(null,'01564634000130','Matrix Sede','Matrix',2),
(null,'01564634000230','Matrix Mogi das Cruzes','Matrix',2),
(null,'26203837000121','AES Tiete Sede','AES TIETE INTEGRA',3);

INSERT INTO Permissoes VALUES
(NULL,1,1,1,1),
(NULL,1,0,0,0);

INSERT INTO Nivel_acesso VALUES
(NULL,'Eng NOC',1),
(NULL,'Gestor',2);

INSERT into Usuario_Dashboard VALUES
(NULL,'davi','davi@teste.com','48372073830','12345678',1,1),
(NULL,'henry','henry@teste.com','12345678910','87654321',1,2),
(NULL, 'Sarah', 'sarah@gmail.com', '8765432109', '98765347', 1,1);

INSERT INTO Alertas VALUES
(1,'Alerta de teste1',default,null,null,1),
(5,'Alerta de teste2',default,null,null,1),
(2,'Alerta de teste2',default,null,null,1),
(9,'Alerta de teste3',default,null,null,1),
(3,'Alerta de teste4',default,null,null,1);

INSERT INTO Componentes_cadastrados values
(null,'CPU'),
(null,'RAM'),
(null,'DISCO'),
(null,'REDE'),
(null,'JANELAS'),
(null,'USB');

INSERT INTO Maquinas VALUES
(null,'teste01',1),
(null,'teste02',1),
(null,'teste03',1),
(null,'teste04',3);

INSERT INTO Componentes_monitorados VALUES
(NULL,1,1),
(NULL,2,1),
(NULL,3,1),
(NULL,4,1),
(NULL,5,1),
(NULL,6,1),
(NULL,1,2),
(NULL,2,2),
(NULL,3,2),
(NULL,4,2),
(NULL,5,2),
(NULL,6,2),
(NULL,1,3),
(NULL,2,3),
(NULL,3,3),
(NULL,4,3),
(NULL,5,3),
(NULL,6,3),
(NULL,1,4),
(NULL,2,4),
(NULL,3,4),
(NULL,4,4),
(NULL,5,4),
(NULL,6,4);

SELECT * FROM Componentes_monitorados;
SELECT * FROM componentes_cadastrados;


-- selects individual sarah

SELECT * FROM Processos;

SELECT * FROM Alerta_Processo;

SELECT nomeProcesso, uso_cpu, uso_ram, tipo_alerta 
FROM 
Alerta_Processo 
WHERE data_hora >= DATE_SUB(NOW(), INTERVAL 1 MINUTE);

SELECT nomeProcesso, 
       data_hora, 
       DATE_FORMAT(data_hora, '%d/%m/%Y %H:%i:%s') as data_formatada
FROM Processos 
WHERE data_hora >= DATE_SUB(NOW(), INTERVAL 1 MINUTE);


SELECT PID, nomeProcesso, data_hora FROM Alerta_Processo WHERE data_hora >= date_sub(now(), interval 1 minute);

-- fim script individual sarah 
