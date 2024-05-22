USE ChildAdvocacyFoundation;

--- Popolamento tabella DIM_VALUTAZIONI ---

INSERT INTO DIM_VALUTAZIONI (ID_Valutazione, Descrizione_Valutazione)
VALUES 
(1,'Incontro Complesso - bassa possibilità di futuri incontri'),
(2,'Incontro Conoscitivo'),
(3,'Incontro Informativo - scambio di informazioni'),
(4,'Incontro propedeutivo al raggiungimento obiettivo strategico'),
(5,'Contribuzione diretta ad obiettivo strategico');

SELECT * FROM DIM_VALUTAZIONI

--- Popolamento tabella DIM_ISTITUZIONI da file csv ---

BULK INSERT DIM_ISTITUZIONI
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_ISTITUZIONI.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_ISTITUZIONI

--- Popolamento tabella DIM_DIREZIONI da file csv ---

BULK INSERT DIM_DIREZIONI
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_DIREZIONI.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_DIREZIONI

--- Popolamento tabella DIM_UFFICI da file csv ---

BULK INSERT DIM_UFFICI
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_UFFICI.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_UFFICI

--- Popolamento tabella DIM_RIFERIMENTI da file csv ---

BULK INSERT DIM_RIFERIMENTI
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_RIFERIMENTI.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_RIFERIMENTI

--- Popolamento tabella DIM_DIPARTIMENTI da file csv ---

BULK INSERT DIM_DIPARTIMENTI
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_DIPARTIMENTI.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_DIPARTIMENTI

--- Popolamento tabella DIM_AREE da file csv ---

BULK INSERT DIM_AREE
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_AREE.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_AREE

--- Popolamento tabella DIM_TEMATICHE da file csv ---

BULK INSERT DIM_TEMATICHE
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_TEMATICHE.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM DIM_TEMATICHE

--- Popolamento tabella DIM_RISORSE da file csv ---

BULK INSERT DIM_RISORSE
FROM 'C:\Users\spetr\Desktop\Capstone Project\DIM_RISORSE - Copia.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

select * FROM DIM_RISORSE

--- Popolamento tabella DIM_KPI_STRATEGICA ---

INSERT INTO DIM_KPI_STRATEGICA (ID_KPI_Strategica, Nome_KPI_Strategica, ID_Dipartimento, Obiettivo, Anno_Inizio_Validita, Anno_Fine_Validita)
VALUES 
(1,'Cambiamenti legislativi', 1, 2, '2022-01-01', '2024-12-31'),
(2,'Cambiamenti di policy', 1, 4, '2022-01-01', '2024-12-31'),
(3,'Cambiamenti di prassi', 1, 8, '2022-01-01', '2024-12-31'),
(4,'Partecipazione', 1, 15, '2022-01-01','2024-12-31'),
(5,'Fondi', 1, 5, '2022-01-01','2024-12-31'),
(6,'Cambiamenti legislativi', 2, 2, '2022-01-01', '2024-12-31'),
(7,'Cambiamenti di policy', 2, 3, '2022-01-01', '2024-12-31'),
(8,'Cambiamenti di prassi', 2, 5, '2022-01-01', '2024-12-31'),
(9,'Partecipazione', 2, 21, '2022-01-01', '2024-12-31'),
(10,'Fondi', 2, 7, '2022-01-01', '2024-12-31');

SELECT * FROM DIM_KPI_STRATEGICA

--- Popolamento tabella DIM_KPI_TEMATICA ---

INSERT INTO DIM_KPI_TEMATICA (ID_KPI_Tematica, Nome_KPI_Tematica, ID_Tematica, ID_KPI_Strategica)
VALUES 
    (1, 'Aumento delle attività di lotta al cyberbullismo', 22, 2),
    (2, 'Aumento della partecipazione dei ragazzi ad attività di piazza', 22, 4),
    (3, 'Definizione linee guida per la lotta alla povertà educativa', 31, 2),
    (4, 'Aumento processi che prevedono la partecipazione dei ragazzi', 31, 4),
    (5, 'Diffusione programmi per lotta alla dispersione scolastica', 1, 3),
    (6, 'Revisione legge su minori coinvolti in attività di criminalità organizzata', 19, 1),
    (7, 'Riconoscimento a livello culturale del lavoro di cura', 20, 3),
    (8, 'Memorandum Understanding con Protezione Civile Italiana', 5, 3),
    (9, 'Aumento fondi per emergenze nazionali', 5, 5),
    (10, 'Aumento fondi per lotta alla povertà diffusa', 32, 5),
    (11, 'Migliore applicazione Legge Zampa', 24, 3),
    (12, 'Legge su cittadinanza a minori stranieri', 30, 1),
    (13, 'Aumento diffusione corsi di lingue non europee nelle scuole', 3, 3),
    (14, 'Introduzione dei mediatori culturali nelle scuole', 3, 1),
    (15, 'Miglioramento fruizione dei servizi in periferia', 13, 3),
    (16, 'Aumento fondi per mense scolastiche', 7, 5),
    (17, 'Aumento municipi ingaggiati', 28, 3),
    (18, 'Aumento fondi per genitori indigenti', 17, 5),
    (19, 'Creazione fondo Minori Vittime di Violenza Assistita', 10, 5),
    (20, 'Riconoscimento della violenza assistita come fenomeno', 10, 2),
    (21, 'Strutturazione di sistemi di monitoraggio capillari', 23, 7),
    (22, 'Aumento visibilità diritti della infanzia nei processi di giustizia internazionale', 14, 8),
    (23, 'Riduzione vendite armi a Stati che violano i diritti minorili', 27, 8),
    (24, 'Aumento fondi per supporto emergenze', 25, 10),
    (25, 'Aumento fondi per lotta alla malnutrizione infantile', 6, 10),
    (26, 'Inclusione protezione della infanzia nel patto europeo', 15, 6),
    (27, 'Inclusione della tematica Infanzia ed Educazione', 9, 6),
    (28, 'Allocazione fondi a ONG', 9, 10),
    (29, 'Inclusione della tematica Infanzia', 21, 7),
    (30, 'Allocazione fondi a società civile', 21, 10),
    (31, 'Aumento processi che prevedono il coinvolgimento dei ragazzi', 29, 9),
    (32, 'Aumento delle attività di piazza con partecipazione dei ragazzi', 4, 9),
    (33, 'Allocazione fondi addizionali a ECW', 11, 10),
    (34, 'Rilancio supporto al fondo GPE', 18, 10),
    (35, 'Inclusione SSD nei manuali militari', 16, 7),
    (36, 'Maggior coinvolgimento interstatale per supporto CLP', 12, 7),
    (37, 'Aumento coinvolgimento delle aziende su HRB', 8, 8),
    (38, 'Rilancio strategia sviluppo sostenibile', 2, 8),
    (39, 'Allocazione fondi PIL su FfD', 26, 10);

SELECT * FROM DIM_KPI_TEMATICA

--- Popolamento tabella FACTS_INCONTRI ---
BULK INSERT FACTS_INCONTRI
FROM 'C:\Users\spetr\Desktop\Capstone Project\Incontri.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

SELECT * FROM FACTS_INCONTRI
