--====================================SUPRESSION DES TABLES EXISTANTES====================================
BEGIN TRY
DROP TABLE [Produit]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE Produit'
END CATCH

BEGIN TRY
DROP TABLE [Vendeur]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE Vendeur'
END CATCH

BEGIN TRY
DROP TABLE [Client]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE Client'
END CATCH

BEGIN TRY
DROP TABLE [Date]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE Date'
END CATCH

BEGIN TRY
DROP TABLE [Vente]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE Vente'
END CATCH

BEGIN TRY
DROP TABLE [BNNE]
END TRY
BEGIN CATCH
Print 'IMPOSSIBLE DE SUPPRIMER LA TABLE BNNE'
END CATCH
--====================================CREATION DES TABLES====================================
CREATE TABLE [Produit] ( 
  [IdProduit] INT IDENTITY(1, 1) NOT NULL,
  [CodeProduit] VARCHAR(20) NULL, 
  [libelléProduit] VARCHAR(20) NULL,
  [Marque] VARCHAR(20) NULL,
PRIMARY KEY ([IdProduit])
);

CREATE TABLE [Vendeur] ( 
  [IdVendeur] INT IDENTITY(1, 1) NOT NULL,
  [matricule] VARCHAR(20) NULL, 
  [nomVendeur] VARCHAR(20) NULL,
  [Ville] VARCHAR(20) NULL,
  [Genre] VARCHAR(10) NULL,
  [Salaire] INT NULL,
PRIMARY KEY ([IdVendeur])
);

CREATE TABLE [Client] ( 
  [IdClient] INT IDENTITY(1, 1) NOT NULL,
  [codeClient] VARCHAR(20) NULL, 
  [nomClient] VARCHAR(20) NULL,
PRIMARY KEY ([IdClient])
);

CREATE TABLE [Date] ( 
  [IdDate] INT IDENTITY(1, 1) NOT NULL, 
  [date] DATE NULL, 
  [mois] INT NULL,
  [année] INT NULL,
PRIMARY KEY ([IdDate])
);

CREATE TABLE [Vente] (
  [IdProduit] INT NULL,
  [IdDate] INT NULL, 
  [IdClient] INT NULL,
  [IdVendeur] INT NULL,
  [Quantité] INT NULL,
  [PrixUnitaire] INT NULL,
  FOREIGN KEY ([IdProduit]) REFERENCES [Produit] ([IdProduit]) ON DELETE CASCADE,
  FOREIGN KEY ([IdDate]) REFERENCES [Date] ([IdDate]) ON DELETE CASCADE,
  FOREIGN KEY ([IdClient]) REFERENCES [Client] ([IdClient]) ON DELETE CASCADE,
  FOREIGN KEY ([IdVendeur]) REFERENCES [Vendeur] ([IdVendeur]) ON DELETE CASCADE
);

CREATE TABLE [BNNE] ( 
  [CodeProduit] VARCHAR(20) NULL,
  [CodeClient] VARCHAR(20) NULL, 
  [nomClient] VARCHAR(20) NULL,
  [matricule] VARCHAR(20) NULL,
  [date] DATE NULL,
  [PrixUnitaire] INT NULL,
  [Quantité] INT NULL
);

-- Insersion et affichages de quelques données dans les tables

    -- Client
INSERT INTO Client(CodeClient, nomClient) VALUES 
('C1', 'Aliou'),
('C2', 'Oumar'),
('C3', 'Papa'),
('C4', 'Maimouna'),
('C5', 'Aly')

    -- Date
INSERT INTO Date(date, mois, année) VALUES 
('2022-03-13', 3, 2022),
('2022-03-14', 3, 2022),
('2022-03-15', 3, 2022),
('2022-03-16', 3, 2022),
('2022-03-17', 3, 2022)

    -- Produit
INSERT INTO Produit(CodeProduit, libelléProduit, Marque) VALUES 
('PRO1', 'Telephone', 'Iphone'), 
('PRO2', 'Telephone', 'TECNO'),
('PRO3', 'Telephone', 'SAMSUNG'),
('PRO4', 'Ordinateur', 'Mac'),
('PRO5', 'Chargeur', 'Unknow')

    -- Vendeur
INSERT INTO Vendeur(matricule, nomVendeur, Ville, Genre, Salaire) VALUES 
('C197', 'Ibrahima', 'Thies', 'M', 240000), 
('C198', 'Eya', 'Tunis', 'F', 200000),
('C199', 'Eya', 'Tunis', 'F', 500000),
('C200', 'Eya', 'Tunis', 'F', 340000),
('C201', 'Shams', 'Tamba', 'M', 5000)

    -- BNNE
INSERT INTO BNNE (CodeProduit, CodeClient, nomClient, matricule, date, PrixUnitaire, Quantité) VALUES 
('PRO1', 'C1', 'Aliou', 'C197', '2022-03-14', 240000, 1),
('PRO2', 'C2', 'Oumar', 'C198', '2022-03-15', 100000, 2),
('PRO3', 'C3', 'Papa', 'C199', '2022-03-15', 100000, 5),
('PRO4', 'C4', 'Maimouna', 'C200', '2022-03-17', 340000, 1),
('PRO5', 'C5', 'Aly', 'C201', '2022-03-17', 5000, 1)
--=============================AFFICHACHE====================================
SELECT *
  FROM [BNNE]

SELECT *
  FROM [Client]

SELECT *
  FROM [Date]

SELECT *
  FROM [Produit]

SELECT *
  FROM [Vendeur]

--=============================QUESTION DEMANDE====================================
-- Requête SQL de chargement de la table Vente à partir de la table BNNE.
-- Q1


INSERT INTO Produit (CodeProduit)
SELECT DISTINCT CodeProduit
FROM BNNE

-- Affichage de la table produit

SELECT *
  FROM [Produit]

-- Q2
--	INSERTION DE LA LIGNE NumLigne dans la table BNNE
ALTER TABLE BNNE add NumLigne INT Identity(1,1);

-- DECLARATION DES VARIABLES
DECLARE 
@i INTEGER,
@taille INTEGER

-- INITIALISATION DES VARIABLES
SET @i = 1;	
SET @taille = (SELECT count(*) FROM BNNE);

-- BOUCLE D'INSERTION
WHILE @i <= @taille
BEGIN
	BEGIN TRY
	INSERT INTO Vente (IdProduit, IdDate, IdClient, IdVendeur, PrixUnitaire, Quantité)
	SELECT IdProduit, IdDate, IdClient, IdVendeur, PrixUnitaire, Quantité
	FROM BNNE, Produit, Vendeur, Client, Date
	WHERE BNNE.CodeProduit = Produit.CodeProduit 
	  AND BNNE.nomClient = Client.nomClient 
	  AND BNNE.date = Date.date 
	  AND BNNE.matricule = Vendeur.matricule
	  AND BNNE.NumLigne = @i
	END TRY
	BEGIN CATCH
		PRINT 'ERREUR POUR LA LIGNE ' + @i
	END CATCH
	SET @i = @i + 1
END

-- AFFICHAGE DE LA TABLE VENTE 
SELECT *
  FROM [Vente]

