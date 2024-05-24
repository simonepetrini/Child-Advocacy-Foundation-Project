--- Creazione della view INCONTRI ---
CREATE VIEW VW_SP_Incontri AS
SELECT 
    F.ID_Incontro, 
	R.ID_Risorsa AS ID_Promotore,
    R.Nome + ' ' + R.Cognome AS Promotore, 
	R2.ID_Risorsa AS ID_Accompagnatore,
    R2.Nome + ' ' + R2.Cognome AS Accompagnatore, 
    FORMAT(F.Data_Incontro, 'dd/MM/yyyy') AS Data, 
    F.Modalita_Incontro AS Modalità, 
    RIF.ID_Riferimento, 
    RIF.Nome_Riferimento AS Riferimento, 
    T.Nome_Tematica AS Tematica, 
	KT.ID_KPI_Tematica,
    KT.Nome_KPI_Tematica AS [KPI Tematica], 
    F.ID_Valutazione AS [Valutazione Incontro], 
    F.Info
FROM FACTS_INCONTRI AS F
JOIN DIM_RIFERIMENTI AS RIF ON F.ID_Riferimento = RIF.ID_Riferimento
JOIN DIM_TEMATICHE AS T ON F.ID_Tematica = T.ID_Tematica
JOIN DIM_KPI_TEMATICA AS KT ON F.ID_KPI_Tematica = KT.ID_KPI_Tematica
JOIN DIM_RISORSE AS R ON F.ID_Promotore = R.ID_Risorsa
JOIN DIM_RISORSE AS R2 ON F.ID_Accompagnatore = R2.ID_Risorsa;

SELECT * FROM VW_SP_Incontri

---- Creazione della view RIFERIMENTI --- 
CREATE VIEW VW_SP_Riferimenti AS 
SELECT R.ID_Riferimento,
		Nome_Istituzione as Istituzione,
		Nome_Direzione AS Direzione,	
		Nome_Ufficio AS Ufficio, 
		Nome_Riferimento AS Riferimento, 
		Partito, 
		Foto		
FROM DIM_RIFERIMENTI as R
JOIN DIM_UFFICI AS I ON R.ID_Ufficio = I.ID_Ufficio
JOIN DIM_DIREZIONI AS D ON I.ID_Direzione = D.ID_Direzione
JOIN DIM_ISTITUZIONI AS IST ON D.ID_Istituzione = IST.ID_Istituzione;

SELECT * FROM VW_SP_Riferimenti

---- Creazione della view RISORSE ---
CREATE VIEW VW_SP_Risorse AS 
SELECT R.ID_Risorsa,
		R.Nome + ' ' + R.Cognome as Risorsa,  
		Ruolo, 
		Nome_Dipartimento AS Dipartimento, 
		Nome_Area as Area, 
		Nome_Tematica as Tematica
FROM DIM_RISORSE AS R
JOIN DIM_TEMATICHE AS T ON R.ID_Tematica = T.ID_Tematica
JOIN DIM_AREE AS A ON T.ID_Area = A.ID_Area
JOIN DIM_DIPARTIMENTI AS D ON A.ID_Dipartimento = D.ID_Dipartimento
WHERE RUOLO = 'Dipendente';

SELECT * FROM VW_SP_Risorse 

---- Creazione della view KPI ---
CREATE VIEW VW_SP_KPI AS 
SELECT KT.ID_KPI_Tematica,
	Nome_KPI_Tematica as [KPI Tematica],
	Nome_Tematica as Tematica,
	KS.ID_KPI_Strategica,
	Nome_KPI_Strategica as [KPI Strategica],
	FORMAT(KS.Anno_Inizio_Validita, 'dd/MM/yyyy') as [Inizio Validità],
	FORMAT(KS.Anno_Fine_Validita, 'dd/MM/yyyy') as [Fine Validità],
	KS.Obiettivo
FROM DIM_KPI_TEMATICA AS KT
JOIN DIM_TEMATICHE AS T ON KT.ID_Tematica = T.ID_Tematica
JOIN DIM_KPI_STRATEGICA AS KS ON KT.ID_KPI_Strategica = KS.ID_KPI_Strategica;

SELECT * FROM VW_SP_KPI

--- Creazione della view legge 231/2007  ---
CREATE VIEW VW_SP_Legge231 AS
SELECT FORMAT(I.Data_Incontro, 'dd/MM/yyyy') AS [Data Incontro], 
		R.Nome + ' ' + R.Cognome AS Promotore, 
		R2.Nome + ' ' + R2.Cognome AS Accompagnatore, 
		D.Nome_Dipartimento AS Dipartimento,
		A.Nome_Area AS Area,
		RIF.Nome_Riferimento AS Riferimento,
		IST.Nome_Istituzione AS Istituzione,
		DIR.Nome_Direzione AS Direzione,
		U.Nome_Ufficio AS Ufficio,
		Modalita_Incontro AS [Modalità Incontro],
		Info
FROM FACTS_INCONTRI AS I
JOIN DIM_RISORSE AS R ON I.ID_Promotore = R.ID_Risorsa
JOIN DIM_RISORSE AS R2 ON I.ID_Accompagnatore = R2.ID_Risorsa
JOIN DIM_DIPARTIMENTI AS D ON R.ID_Dipartimento = D.ID_Dipartimento
JOIN DIM_AREE AS A ON A.ID_Area = R.ID_Area
JOIN DIM_RIFERIMENTI AS RIF ON I.ID_Riferimento = RIF.ID_Riferimento
JOIN DIM_ISTITUZIONI AS IST ON I.ID_Istituzione = IST.ID_Istituzione
JOIN DIM_DIREZIONI AS DIR ON I.ID_Direzione = DIR.ID_Direzione
JOIN DIM_UFFICI AS U ON I.ID_Ufficio = U.ID_Ufficio
WHERE IST.Nome_Istituzione <> 'Private' AND YEAR(Data_Incontro) = 2024

SELECT * FROM VW_SP_Legge231
