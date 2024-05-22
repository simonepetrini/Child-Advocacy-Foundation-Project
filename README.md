# Child Advocacy Foundation Project

### Case Study

Un'ipotetica Organizzazione Non Governativa, operante nel settore della tutela dei diritti dell'infanzia ed attiva in diversi stati del mondo, richiede consulenza per rispondere a due importanti esigenze del proprio dipartimento di Advocacy:

- la realizzazione di un report annuale in PowerBI che esponga, nel dettaglio, i progressi nel campo Advocacy ottenuti tramite i vari incontri di natura istituzionale e non, in relazione agli obiettivi programmatici a cadenza pluriennale;
- l'estrazione, sempre con cadenza annuale, dell'elenco completo degli incontri istituzionali nazionali ed internazionali avuti dai singoli componenti del dipartimento come da richiesta della legge 231/2007 per la repressione del riciclaggio di denaro, beni o altre utilità, che obbliga le ONG a tenere traccia di ogni incontro con enti istituzionali e governativi.

Richiede inoltre una riorganizzazione delle fonti dati interne all'Organizzazione, tramite la creazione di un DataBase di tipo OLTP.
La creazione del DB permetterà ai singoli dipendenti del dipartimento l'inserimento dei singoli report istituzionali, evitando possibili ridondanze e manipolazioni emerse con l'attuale sistema di registrazione (inserimento massivo dei record su file Excel non protetto).

#### Fase 1: Progettazione Concettuale della Base Dati: 

![alt text](https://github.com/simonepetrini/Child-Advocacy-Foundation-Project/blob/main/Progettazione%20Concettuale.jpg)

#### Nota a margine: Il modello rispetto alla raffigurazione presentata ha subito l'implementazione della dimensione Riferimenti (originariamente preventivata come campo libero). Si allega immagine integrativa per descrivere le relazioni che intercorrono tra la nuova dimensione Riferimenti e le altre tabelle presenti nel modello

![alt text](https://github.com/simonepetrini/Child-Advocacy-Foundation-Project/blob/main/Progettazione%20Concettuale2.jpg)

#### Fase 2: Creazione del Database e implementazione fisica delle tabelle: 

```sql
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
```
#### Fase 3: Creazione di un file csv "Anagrafiche" utile per generare i dati con cui popolare le dimensioni Risorse, Dipartimenti, Aree e Tematiche: 

Nell'ottica di uno scenario aziendale plausibile, in cui l'implementazione di un database non viene fatta ex-novo, ma attingendo a dati facilmente reperibili da vari strumenti aziendali, ho immaginato che il popolamento delle dimensioni relative alle Risorse interne all'organizzazione e, di conseguenza, alla gerarchia in cui strutturare i dipartimenti di Advocacy, potesse essere effettuato attingendo ad un'esportazione dati generata da un ipotetico portale aziendale gestito dalle risorse umane; Quest'esportazione si concretizza in un file .csv riepilogativo di tutti i dati necessari al popolamento della tabella DIM_RISORSE, che sono andato a denormalizzare per ottenere ulteriori file .csv utili al popolamento delle altre tabelle derivate (DIM_DIPARTIMENTI, DIM_AREE e DIM_TEMATICHE).

Per generare il file.csv delle risorse mi sono avvalso della libreria Random di Python

```python
import pandas as pd
import random
from datetime import datetime, timedelta
import string

# Creazione di una lista con i 100 nomi più diffusi in Italia
nomi = [
        "Francesco", "Alessandro", "Lorenzo", "Mattia", "Leonardo", "Andrea", "Gabriele", "Matteo", "Riccardo", "Davide", "Giuseppe", "Simone",
        "Marco", "Antonio", "Federico", "Giovanni", "Luca", "Filippo", "Christian", "Nicola", "Stefano", "Tommaso", "Edoardo", "Alberto",
        "Raffaele", "Michele", "Daniele", "Giorgio", "Enrico", "Rocco", "Emanuele", "Roberto", "Diego", "Massimo", "Vincenzo", "Fabio",
        "Paolo", "Salvatore", "Emiliano", "Giacomo", "Angelo", "Pietro", "Domenico", "Mario", "Claudio", "Sergio", "Nicolò", "Dario", "Giulio",
        "Alessio", "Giulia", "Sofia", "Aurora", "Alice", "Ginevra", "Emma", "Martina", "Chiara", "Giorgia", "Sara", "Francesca", "Anna",
        "Beatrice", "Eleonora", "Elisa", "Laura", "Alessia", "Valentina", "Matilde", "Ludovica", "Greta", "Luna", "Viola", "Lucia",
        "Alessandra", "Vittoria", "Noemi", "Caterina", "Federica", "Elena", "Roberta", "Serena", "Camilla", "Linda", "Carolina", "Rachele",
        "Bianca", "Nicole", "Miriam", "Silvia", "Veronica", "Stella", "Eva", "Lisa", "Simona", "Cristina", "Isabella", "Rosanna", "Nina",
        "Arianna"
    ]

# Dalla lista nomi estrapolo quelli di genere femminile, utili per la generazione del codice fiscale
nomi_femminili = [
            "Giulia", "Sofia", "Aurora", "Alice", "Ginevra", "Emma", "Martina", "Chiara", "Giorgia", "Sara", "Francesca", "Anna", "Beatrice", 
            "Eleonora", "Elisa", "Laura", "Alessia", "Valentina", "Matilde", "Ludovica", "Greta", "Luna", "Viola", "Lucia", "Alessandra", 
            "Vittoria", "Noemi", "Caterina", "Federica", "Elena", "Roberta", "Serena", "Camilla", "Linda", "Carolina", "Rachele", "Bianca", 
            "Nicole", "Miriam", "Silvia", "Veronica", "Stella", "Eva", "Lisa", "Simona", "Cristina", "Isabella", "Rosanna", "Nina", "Arianna"
    ]

# Creazione di una lista con i 100 cognomi più diffusi in Italia
cognomi = [
        "Rossi", "Russo", "Ferrari", "Esposito", "Bianchi", "Romano", "Colombo", "Ricci", "Marino", "Greco", "Bruno", "Gallo", "Conti", "De Luca",
        "Mancini", "Costa", "Giordano", "Rizzo", "Lombardi", "Moretti", "Barbieri", "Fontana", "Santoro", "Mariani", "Rinaldi", "Caruso", 
        "Ferrara", "Galli", "Martini", "Leone", "Longo", "Gentile", "Martinelli", "Vitale", "Lombardo", "Serra", "Coppola", "De Santis", 
        "D'Angelo", "Marchetti", "Parisi", "Villa", "Conte", "Ferraro", "Ferri", "Fabbri", "Bianco", "Marini", "Grasso", "Valentini", "Messina", 
        "Sala", "De Angelis", "Gatti", "Pellegrini", "Palumbo", "Sanna", "Farina", "Rizzi", "Monti", "Cattaneo", "Morelli", "Amato", "Silvestri", 
        "Mazza", "Testa", "Grassi", "Palmieri", "Bernardi", "Fiore", "De Rosa", "D'Amico", "Giuliani", "Cattaneo", "Riva", "Marra", "Sartori", 
        "Ruggiero", "Longo", "Neri", "Barone", "Caputo", "Montanari", "Guerra", "Sacco", "Carbone", "Salvatore", "Messi", "De Angelis"
    ]

# Creo la lista nomi_casuali, popolandola con 100 record casuali dalla lista dei nomi
nomi_casuali = random.choices(nomi, k=100)

# Creo la lista cognomi_casuali, popolandola con 100 record casuali dalla lista dei cognnomi
cognomi_casuali = random.choices(cognomi, k=100)

# Creo il DataFrame
Anagrafiche = pd.DataFrame({
    'Nome': nomi_casuali,
    'Cognome': cognomi_casuali
})



```
