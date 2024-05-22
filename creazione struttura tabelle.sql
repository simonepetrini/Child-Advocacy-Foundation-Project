--- Creazione DB Child Advocacy Foundation ---
CREATE DATABASE ChildAdvocacyFoundation;
USE ChildAdvocacyFoundation;

--- Creazione della struttura delle tabelle ---
CREATE TABLE DIM_DIPARTIMENTI
(
ID_Dipartimento INT NOT NULL,
Nome_Dipartimento nvarchar(30)
CONSTRAINT PK_DIPARTIMENTI PRIMARY KEY (ID_Dipartimento)
);

CREATE TABLE DIM_VALUTAZIONI
(
ID_Valutazione INT NOT NULL,
Descrizione_Valutazione nvarchar(100)
CONSTRAINT PK_VALUTAZIONI PRIMARY KEY (ID_Valutazione)
);

CREATE TABLE DIM_ISTITUZIONI
(
ID_Istituzione INT NOT NULL,
Nome_Istituzione nvarchar(100)
CONSTRAINT PK_ISTITUZIONI PRIMARY KEY (ID_Istituzione)
);

CREATE TABLE DIM_DIREZIONI
(
ID_Direzione INT NOT NULL,
Nome_Direzione nvarchar(100),
ID_Istituzione INT
CONSTRAINT PK_DIREZIONI PRIMARY KEY (ID_Direzione),
CONSTRAINT FK_DIREZIONI_ISTITUZIONI FOREIGN KEY (ID_Istituzione) REFERENCES DIM_ISTITUZIONI(ID_Istituzione)
);

CREATE TABLE DIM_UFFICI
(
ID_Ufficio INT NOT NULL,
Nome_Ufficio nvarchar(MAX),
ID_Direzione INT
CONSTRAINT PK_UFFICI PRIMARY KEY (ID_Ufficio),
CONSTRAINT FK_UFFICI_DIREZIONI FOREIGN KEY (ID_Direzione) REFERENCES DIM_DIREZIONI(ID_Direzione)
);

CREATE TABLE DIM_RIFERIMENTI
(
ID_Riferimento INT NOT NULL,
Nome_Riferimento nvarchar(100),
Partito nvarchar(100),
Foto nvarchar(MAX),
ID_Ufficio INT
CONSTRAINT PK_RIFERIMENTO PRIMARY KEY (ID_Riferimento),
CONSTRAINT FK_RIFERIMENTI_UFFICI FOREIGN KEY (ID_Ufficio) REFERENCES DIM_UFFICI(ID_Ufficio)
);


CREATE TABLE DIM_AREE
(
ID_Area INT NOT NULL,
Nome_Area nvarchar(100),
ID_Dipartimento INT
CONSTRAINT PK_AREE PRIMARY KEY (ID_Area),
CONSTRAINT FK_AREE_DIPARTIMENTI FOREIGN KEY (ID_Dipartimento) REFERENCES DIM_DIPARTIMENTI(ID_Dipartimento)
);

CREATE TABLE DIM_TEMATICHE
(
ID_Tematica INT NOT NULL,
Nome_Tematica nvarchar(100),
Descrizione_Tematica nvarchar(300),
ID_Area INT
CONSTRAINT PK_TEMATICHE PRIMARY KEY (ID_Tematica),
CONSTRAINT FK_TEMATICHE_AREE FOREIGN KEY (ID_Area) REFERENCES DIM_AREE(ID_Area)
);

CREATE TABLE DIM_RISORSE
(
ID_Risorsa INT NOT NULL,
Nome nvarchar(30),
Cognome nvarchar (30),
Data di Nascita date,
Sesso char(1),
Codice_Fiscale char(16),
Ruolo nvarchar(30),
ID_Dipartimento INT,
ID_Area INT,
ID_Tematica INT,
Data_Assunzione date,
Data_Fine_Rapporto date,
Data_Inizio_Ruolo date,
Data_Fine_Ruolo date,
Stato_Ruolo nvarchar(30),
Mail nvarchar(255),
LoginID nvarchar(50)
CONSTRAINT PK_RISORSE PRIMARY KEY (ID_Risorsa),
CONSTRAINT FK_RISORSE_DIPARTIMENTI FOREIGN KEY (ID_Dipartimento) REFERENCES DIM_DIPARTIMENTI(ID_Dipartimento),
CONSTRAINT FK_RISORSE_AREE FOREIGN KEY (ID_Area) REFERENCES DIM_AREE(ID_Area),
CONSTRAINT FK_RISORSE_TEMATICHE FOREIGN KEY (ID_Tematica) REFERENCES DIM_TEMATICHE(ID_Tematica)
);

CREATE TABLE DIM_KPI_STRATEGICA
(
ID_KPI_Strategica INT NOT NULL,
Nome_KPI_Strategica nvarchar(100),
ID_Dipartimento INT,
Obiettivo INT,
Anno_Inizio_Validita date,
Anno_Fine_Validita date
CONSTRAINT PK_KPI_STRATEGICA PRIMARY KEY (ID_KPI_Strategica),
CONSTRAINT FK_KPI_STRATEGICA_DIPARTIMENTI FOREIGN KEY (ID_Dipartimento) REFERENCES DIM_DIPARTIMENTI(ID_Dipartimento)
);

CREATE TABLE DIM_KPI_TEMATICA
(
ID_KPI_Tematica INT NOT NULL,
Nome_KPI_Tematica nvarchar(100),
ID_Tematica INT,
ID_KPI_Strategica INT,
CONSTRAINT PK_KPI_TEMATICA PRIMARY KEY (ID_KPI_Tematica),
CONSTRAINT FK_KPI_TEMATICA_TEMATICHE FOREIGN KEY (ID_Tematica) REFERENCES DIM_TEMATICHE(ID_Tematica),
CONSTRAINT FK_KPI_TEMATICA_STRATEGICA FOREIGN KEY (ID_KPI_Strategica) REFERENCES DIM_KPI_STRATEGICA(ID_KPI_Strategica)
);

CREATE TABLE FACTS_INCONTRI
(
ID_Incontro INT NOT NULL,
ID_Promotore INT,
ID_Accompagnatore INT,
Data_Incontro date,
Modalita_Incontro nvarchar(8),
ID_Istituzione INT,
ID_Direzione INT,
ID_Ufficio INT,
ID_Riferimento INT,
ID_Tematica INT,
ID_KPI_Tematica INT,
ID_Valutazione INT,
Info nvarchar(300)
CONSTRAINT PK_INCONTRI PRIMARY KEY (ID_Incontro),
CONSTRAINT FK_INCONTRI_RISORSE_PROMOTORE FOREIGN KEY (ID_Promotore) REFERENCES DIM_RISORSE(ID_Risorsa),
CONSTRAINT FK_INCONTRI_RISORSE_ACCOMPAGNATORE FOREIGN KEY (ID_Accompagnatore) REFERENCES DIM_RISORSE(ID_Risorsa),
CONSTRAINT FK_INCONTRI_ISTITUZIONI FOREIGN KEY (ID_Istituzione) REFERENCES DIM_ISTITUZIONI(ID_Istituzione),
CONSTRAINT FK_INCONTRI_DIREZIONI FOREIGN KEY (ID_Direzione) REFERENCES DIM_DIREZIONI(ID_Direzione),
CONSTRAINT FK_INCONTRI_UFFICI FOREIGN KEY (ID_Ufficio) REFERENCES DIM_UFFICI(ID_Ufficio),
CONSTRAINT FK_INCONTRI_RIFERIMENTI FOREIGN KEY (ID_Riferimento) REFERENCES DIM_RIFERIMENTI(ID_Riferimento),
CONSTRAINT FK_INCONTRI_TEMATICHE FOREIGN KEY (ID_Tematica) REFERENCES DIM_TEMATICHE(ID_Tematica),
CONSTRAINT FK_INCONTRI_KPI_TEMATICA FOREIGN KEY (ID_KPI_Tematica) REFERENCES DIM_KPI_TEMATICA(ID_KPI_Tematica),
CONSTRAINT FK_INCONTRI_VALUTAZIONI FOREIGN KEY (ID_Valutazione) REFERENCES DIM_VALUTAZIONI(ID_Valutazione)
);

