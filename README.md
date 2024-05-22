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

# Creo una funzione che generi la data di nascita secondo alcuni criteri verosimili
def genera_data_nascita():
    # Genera un anno casuale tra 1960 (anno massimo per pensionamento) e 2005 (in maniera tale da essere sicuri che gli assunti siano maggiorenni)
    anno = random.randint(1960, 2005)
    # Genera un mese casuale tra 1 e 12
    mese = random.randint(1, 12)
    # Genera un giorno casuale tra 1 e il massimo numero di giorni per il mese e l'anno specificati
    giorno = random.randint(1, (datetime(anno, mese % 12 + 1, 1) - timedelta(days=1)).day)
    # Formatta la data come 'AAAA-MM-GG' e la restituisce
    data_nascita = datetime(anno, mese, giorno)
    return data_nascita

Anagrafiche['Data di Nascita'] = Anagrafiche.apply(lambda _: genera_data_nascita(), axis=1)

# Funzione per determinare il sesso in base al nome
def determina_sesso(nome):
    if nome in nomi_femminili:
        return 'F'
    else:
        return 'M'

Anagrafiche['Sesso'] = Anagrafiche['Nome'].apply(lambda x: determina_sesso(x))

# Funzione che seleziona solo le prime 3 consonanti da una stringa
def prime_consonanti(s):
    consonanti = 'bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ'
    prime_consonanti = ''
    for char in s:
        if char in consonanti:
            prime_consonanti += char
        if len(prime_consonanti) == 3:
            break
    # Se la lunghezza delle consonanti è inferiore a 3, aggiungi le prime vocali necessarie
    if len(prime_consonanti) < 3:
        vocali = 'aeiouAEIOU'
        for char in s:
            if char in vocali:
                prime_consonanti += char
            if len(prime_consonanti) == 3:
                break
    return prime_consonanti

# Funzione che genera il codice fiscale
def genera_codice_fiscale(nome, cognome, sesso, data_nascita_str):
    data_nascita = datetime.strptime(data_nascita_str, '%Y-%m-%d')
    lettere = string.ascii_uppercase
    cifre = string.digits
    
    nome = nome.upper()
    cognome = cognome.upper()
    
    anno_nascita = str(data_nascita.year)[-2:]
    mese_nascita = str(data_nascita.month).zfill(2)
    giorno_nascita = str(data_nascita.day).zfill(2)
    
    codice_comune1 = ''.join(random.choices(lettere, k=1))
    codice_controllo = ''.join(random.choices(cifre, k=3))
    codice_comune2 = ''.join(random.choices(lettere, k=1))
    
    if sesso == "F":
        giorno_nascita = str(int(giorno_nascita) + 40)
        
    mesi = {
        "01": "A", "02": "B", "03": "C", "04": "D", "05": "E", "06": "H",
        "07": "L", "08": "M", "09": "P", "10": "R", "11": "S", "12": "T"
    }
    
    mese_nascita = mesi.get(mese_nascita)  
    
    codice_fiscale = prime_consonanti(cognome.replace(' ', '').replace("'", '')) + prime_consonanti(nome.replace(' ', '').replace("'", '')) + anno_nascita + mese_nascita + giorno_nascita + codice_comune1 + codice_controllo + codice_comune2   
    return codice_fiscale

# Inseriamo la colonna Codice Fiscale nel dataframe
Anagrafiche['Codice Fiscale'] = [genera_codice_fiscale(nome, cognome, sesso, data_nascita.strftime('%Y-%m-%d')) 
                        for nome, cognome, sesso, data_nascita in zip(Anagrafiche['Nome'], Anagrafiche['Cognome'], Anagrafiche['Sesso'], Anagrafiche['Data di Nascita'])]

# Definizione Ruolo e aggiunta al datafram

def determina_ruolo(index):
    if index < 2:
        return 'Direttore'
    else:
        return 'Dipendente'
    
Anagrafiche['Ruolo'] = Anagrafiche.index.to_series().apply(determina_ruolo)

# Definizione delle opzioni per Dipartimento, Area e Tematica

opzioni_dipartimento = ["Advocacy Nazionale", "Advocacy Internazionale"]
opzioni_area = {
    "Advocacy Nazionale": ["Educazione", "Povertà", "Migrazione & Accoglienza", "Progetti Locali", "Salute"],
    "Advocacy Internazionale": ["Crisi Umanitarie", "Migrazione", "Clima", "Istruzione", "Private"]
}
opzioni_tematica = {
    "Educazione": ["Bullismo", "Povertà Educativa", "Dispersione Scolastica"],
    "Povertà": ["Criminalità Minorile", "Lavoro di Cura", "Supporto a Famiglie Vittime di Emergenze", "Reddito di Inclusione/Cittadinanza"],
    "Migrazione & Accoglienza": ["Minori Stranieri non Accompagnati", "Cittadinanza", "Inclusione"],
    "Progetti Locali": ["Periferie", "Mense Scolastiche", "Quartieri d’Innovazione"],
    "Salute": ["Supporto alla Genitorialità", "Supporto a Minori Vittime di Violenza Assistita"],
    "Crisi Umanitarie": ["Children and Armed Conflict", "Accountability", "Armi", "Aree Geografiche", "Fame"],
    "Migrazione": ["Patto Asilo Migrazione", "Piano Mattei"],
    "Clima": ["Processo COP", "Partecipazione Giovanile", "Generation Hope"],
    "Istruzione": ["Education Cannot Wait", "Global Partnership for Education", "Safe School Declaration"],
    "Private": ["Child Labour Policy", "Human Rights and Business", "Agenda 2030", "Financing for Development"]
}

# Creazione funzione per determinare il Dipartimento e aggiunta della colonna al dataframe

Anagrafiche['Dipartimento'] = ''

def determina_dipartimento(index, ruolo):
    if ruolo == 'Direttore':
        if index == 0:
            return 'Advocacy Nazionale'
        elif index == 1:
            return 'Advocacy Internazionale'
    elif ruolo == 'Dipendente':
        if index % 2 == 0:
            return 'Advocacy Nazionale'
        else:
            return 'Advocacy Internazionale'

Anagrafiche['Dipartimento'] = Anagrafiche.apply(lambda x: determina_dipartimento(x.name, x['Ruolo']), axis=1)

# Creazione funzione per determinare l'Area e aggiunta della colonna al dataframe

def assegna_area(dipartimento, ruolo):
    if ruolo == "Direttore":
        area = None
    else:
        area = random.choice(opzioni_area[dipartimento])
    return area

Anagrafiche['Area'] = Anagrafiche.apply(lambda row: assegna_area(row['Dipartimento'], row['Ruolo']), axis=1)

# Creazione funzione per determinare la Tematica e aggiunta della colonna al dataframe

def assegna_tematica(area, ruolo):
    if ruolo == "Direttore":
        tematica = None
    else:
        tematica = random.choice(opzioni_tematica[area])
    return tematica

Anagrafiche['Tematica'] = Anagrafiche.apply(lambda row: assegna_tematica(row['Area'], row['Ruolo']), axis=1)

# Funzione per generare la data di assunzione tra 01/01/2018 e 26/04/2024 (tenendo conto della maggiore età dell'assunto)

def genera_data_assunzione(data_nascita, ruolo):
    # Per il ruolo Direttore assumiamo che la data di assunzione coincida con la prima data aziendale utile
    if ruolo == "Direttore":
        return datetime.strptime("01/01/2018", "%d/%m/%Y")
    else:
        # Generazione di una data casuale compresa tra il 01/01/2018 e il 26/04/2024
        data_assunzione = datetime(
            random.randint(2018, 2024),  # Anno casuale tra il 2018 e il 2024
            random.randint(1, 12),        # Mese casuale
            random.randint(1, 28)         # Giorno casuale (assumendo sempre un massimo di 28 giorni per semplicità)
        )
        # Controllo per assicurarsi che siano trascorsi almeno 18 anni tra data di nascita e data di assunzione
        while (data_assunzione - data_nascita).days < 18 * 365:
            data_assunzione = datetime(
                random.randint(2018, 2024),
                random.randint(1, 12),
                random.randint(1, 28)
            )
        return data_assunzione

Anagrafiche['Data Assunzione'] = Anagrafiche.apply(lambda row: genera_data_assunzione(row['Data di Nascita'], row['Ruolo']), axis=1)

# Definizione della funzione per generare la data fine rapporto (presente in solo 5 record del dataset):
def random_date(start, end):
    return start + timedelta(seconds=random.randint(0, int((end - start).total_seconds())))

def genera_data_fine_rapporto(ruolo, data_assunzione):
    if ruolo == "Direttore":
        return None
    else:
        if data_assunzione <= datetime(2024, 4, 26):
            if random.random() < 0.05:  # Probabilità del 5% di avere una data di fine rapporto
                return random_date(data_assunzione, datetime(2024, 4, 26)).strftime("%Y/%m/%d")
        return None

Anagrafiche['Data Fine Rapporto'] = Anagrafiche.apply(lambda row: genera_data_fine_rapporto(row['Ruolo'], row['Data Assunzione']), axis=1)

Anagrafiche['Data Inizio Ruolo'] = Anagrafiche['Data Assunzione']

# Funzione per calcolare la Data Fine Ruolo 

def calcola_data_fine_ruolo(ruolo, data_assunzione):
    if ruolo == "Direttore":
        return None
    elif ruolo == "Dipendente":
        if data_assunzione <= datetime(2024, 4, 26):
            if random.random() < 0.05:
                return random_date(data_assunzione, datetime(2024, 4, 26)).strftime("%Y/%m/%d")
        return None
            
Anagrafiche['Data Fine Ruolo'] = Anagrafiche.apply(lambda row: calcola_data_fine_ruolo(row['Ruolo'], row['Data Assunzione']), axis=1)

# Definizione della funzione per determinare lo stato del ruolo
def determina_stato_ruolo(data_fine_ruolo):
    if data_fine_ruolo is not None:
        return 'Cessato'
    else:
        return 'Attivo'
    
Anagrafiche['Stato Ruolo'] = Anagrafiche['Data Fine Ruolo'].apply(determina_stato_ruolo)

# Funzione per duplicare i record quando Data Fine Ruolo non è None
def duplica_record(row):
    if row['Data Fine Ruolo'] is not None:
        new_row = row.copy()  # Copia tutti i valori del record attuale
        new_row['Area'] = random.choice(opzioni_area[row['Dipartimento']])  # Assegna una nuova Area
        new_row['Tematica'] = random.choice(opzioni_tematica[new_row['Area']])  # Assegna una nuova Tematica
        new_row['Data Fine Rapporto'] = None  # Resetta la Data Fine Rapporto
        new_row['Data Inizio Ruolo'] = row['Data Fine Ruolo']  # Imposta la Data Inizio Ruolo al valore precedente di Data Fine Ruolo
        new_row['Data Fine Ruolo'] = None  # Resetta la Data Fine Ruolo
        new_row['Stato Ruolo'] = 'Attivo'  # Imposta lo Stato Ruolo a 'Attivo' per il nuovo record
        return new_row
    else:
        return None

# Creazione del DataFrame Anagrafiche Duplicati
Anagrafiche_Duplicati = pd.DataFrame(columns=Anagrafiche.columns)

# Itera su ciascuna riga di Anagrafiche e applica la funzione duplica_record
for index, row in Anagrafiche.iterrows():
    new_row = duplica_record(row)
    if new_row is not None:
        # Aggiungi il nuovo record a Anagrafiche Duplicati
        Anagrafiche_Duplicati = pd.concat([Anagrafiche_Duplicati, pd.DataFrame([new_row])], ignore_index=True)

# Accoda i nuovi record di Anagrafiche Duplicati a Anagrafiche
Anagrafiche = pd.concat([Anagrafiche, Anagrafiche_Duplicati], ignore_index=True)

# Funzione per generare un indirizzo email
def generate_email(row):
    # Rimuovi gli spazi e gli apostrofi dai nomi prima di generare l'email
    nome = row['Nome'].replace(' ', '').replace("'", '')
    cognome = row['Cognome'].replace(' ', '').replace("'", '')
    return f"{nome.lower()}.{cognome.lower()}@childadvocacyfoundation.org"
    
Anagrafiche['Mail'] = Anagrafiche.apply(generate_email, axis=1)

# Funzione per generare un LoginID
def generate_login(row):
    # Rimuovi gli spazi e gli apostrofi dai nomi prima di generare la login
    nome = row['Nome'].replace(' ', '').replace("'", '')
    cognome = row['Cognome'].replace(' ', '').replace("'", '')
    return f"{nome.lower()}.{cognome.lower()}"

Anagrafiche['LoginID'] = Anagrafiche.apply(generate_login, axis=1)

percorso_file_csv = "anagrafiche.csv"
Anagrafiche.to_csv(percorso_file_csv, index=False)
```

Denormalizzazione del file anagrafiche.csv per creare i vari file per popolare le tabelle DIM_DIPARTIMENTI, DIM_AREE e DIM_TEMATICHE e DIM_RISORSE

```python
import pandas as pd

#Creazione del file DIM_DIPARTIMENTI
Anagrafiche_link = "anagrafiche.csv"
Anagrafiche = pd.read_csv(Anagrafiche_link)
lista_dipartimenti = Anagrafiche['Dipartimento'].unique().tolist()
ID_Dipartimento = [f"{str(i+1)}" for i in range(len(lista_dipartimenti))]
dizionario_dipartimenti = dict(zip(ID_Dipartimento, lista_dipartimenti))
DIM_DIPARTIMENTI = pd.DataFrame(list(dizionario_dipartimenti.items()), columns=['ID_Dipartimento', 'Nome_Dipartimento'])
DIM_DIPARTIMENTI.to_csv('DIM_DIPARTIMENTI.csv', index=False)

#Creazione del file DIM_AREE
aree = Anagrafiche.iloc[:, 6:8]
aree = aree[['Dipartimento', 'Area']].drop_duplicates()
aree.rename(columns={'Dipartimento': 'Nome_Dipartimento'}, inplace=True)
aree = aree.dropna(subset=['Area'])
aree = pd.merge(aree, DIM_DIPARTIMENTI, on='Nome_Dipartimento', how='left')
aree.drop('Nome_Dipartimento', axis=1, inplace=True)
aree.rename(columns={'Area': 'Nome_Area'}, inplace=True)
ID_Area = [f"{str(i+1)}" for i in range(len(aree))]
aree['ID_Area'] = ID_Area
nuovo_ordine = ['ID_Area', 'Nome_Area', 'ID_Dipartimento']
aree = aree.reindex(columns=nuovo_ordine)
aree.to_csv('DIM_AREE.csv', index=False)

#Creazione del file DIM_TEMATICHE
tematiche = Anagrafiche.iloc[:, 7:9]
tematiche = tematiche[['Area', 'Tematica']].drop_duplicates()
tematiche.rename(columns={'Area': 'Nome_Area'}, inplace=True)
tematiche = tematiche.dropna(subset=['Tematica'])
tematiche = pd.merge(tematiche, aree, on='Nome_Area', how='left')
tematiche['Descrizione_Tematica'] = None   # Colonna compilata con None ma prevista per future indicazioni 
tematiche.rename(columns={'Tematica': 'Nome_Tematica'}, inplace=True)
tematiche.drop('Nome_Area', axis=1, inplace=True)
tematiche.drop('ID_Dipartimento', axis=1, inplace=True)
ID_Tematica = [f"{str(i+1)}" for i in range(len(tematiche))]
tematiche['ID_Tematica'] = ID_Tematica
nuovo_ordine = ['ID_Tematica', 'Nome_Tematica', 'Descrizione_Tematica', 'ID_Area']
tematiche = tematiche.reindex(columns=nuovo_ordine)
tematiche.to_csv('DIM_TEMATICHE.csv', index=False)

#Creazione del file DIM_RISORSE
DIM_DIPARTIMENTI.rename(columns={'Nome_Dipartimento': 'Dipartimento'}, inplace=True)
aree.rename(columns={'Nome_Area': 'Area'}, inplace=True)
tematiche.rename(columns={'Nome_Tematica': 'Tematica'}, inplace=True)
Anagrafiche_Dipartimenti = pd.merge(Anagrafiche, DIM_DIPARTIMENTI, on='Dipartimento', how='inner')
Anagrafiche_Dipartimenti.drop('Dipartimento', axis=1, inplace=True)
Anagrafiche_Aree = pd.merge(Anagrafiche_Dipartimenti, aree, on='Area', how='left')
Anagrafiche_Aree.drop('Area', axis=1, inplace=True)
Anagrafiche_Aree.drop('ID_Dipartimento_y', axis=1, inplace=True)
Anagrafiche_Aree.rename(columns={'ID_Dipartimento_x' : 'ID_Dipartimento'}, inplace=True)
Anagrafiche_Tematiche = pd.merge(Anagrafiche_Aree, tematiche, on='Tematica', how='left')
Anagrafiche_Tematiche.drop('Tematica', axis=1, inplace=True)
Anagrafiche_Tematiche.drop('ID_Area_y', axis=1, inplace=True)
Anagrafiche_Tematiche.rename(columns={'ID_Area_x' : 'ID_Area'}, inplace=True)
Anagrafiche_Tematiche.drop('Descrizione_Tematica', axis=1, inplace=True)
ID_Risorsa = [f"{str(i+1)}" for i in range(len(Anagrafiche_Tematiche))]
Anagrafiche_Tematiche['ID_Risorsa'] = ID_Risorsa

Anagrafiche_Tematiche.rename(columns={'Data di Nascita' : 'Data_di_Nascita'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Codice Fiscale' : 'Codice_Fiscale'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Data Assunzione' : 'Data_Assunzione'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Data Fine Rapporto' : 'Data_Fine_Rapporto'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Data Inizio Ruolo' : 'Data_Inizio_Ruolo'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Data Fine Ruolo' : 'Data_Fine_Ruolo'}, inplace=True)
Anagrafiche_Tematiche.rename(columns={'Stato Ruolo' : 'Stato_Ruolo'}, inplace=True)

nuovo_ordine = ['ID_Risorsa', 'Nome', 'Cognome', 'Data_di_Nascita', 'Sesso', 'Codice_Fiscale', 'Ruolo', 'ID_Dipartimento', 'ID_Area', 'ID_Tematica',
                'Data_Assunzione', 'Data_Fine_Rapporto', 'Data_Inizio_Ruolo', 'Data_Fine_Ruolo', 'Stato_Ruolo', 'Mail', 'LoginID']
Anagrafiche_Tematiche = Anagrafiche_Tematiche.reindex(columns=nuovo_ordine)
Anagrafiche_Tematiche.to_csv('DIM_RISORSE.csv', index=False)
```

#### Fase 4: Estrazione dati online tramite web scraping con la libreria BeautifulSoup di Python per popolare le tabelle DIM_ISTITUZIONI, DIM_DIREZIONI, DIM_UFFICI E DIM_RIFERIMENTI: 

Per popolare le tabelle DIM_ISTITUZIONI, DIM_DIREZIONI, DIM_UFFICI E DIM_RIFERIMENTI ho creato uno script Python utilizzando la libreria BeautifulSoup per estrapolare le anagrafiche di interesse.
Ho deciso di limitare il numero delle istituzioni analizzabili ai soli Parlamento Italiano, Governo Italiano, Parlamento Europeo, Settore Private e Altro.
Per il Parlamento Italiano ho estratto, dai siti istituzionali della Camera dei Deputati e del Senato della Repubblica, tutti i componenti delle relative Commissioni Permanenti; per il Governo Italiano ho estratto la lista dei ministri dal sito del Senato; per il Parlamento Europeo la lista di tutti i parlamentari europei dal sito https://www.europarl.europa.eu/meps/it; per il settore Private ho scaricato dal sito del Sole 24 Ore la lista aggiornata delle 200 aziende italiane leader della sostenibilità (per cui ho generato i riferimenti utilizzando lo stesso criterio di randomicità utilizzato per la creazione delle risorse dell'organizzazione; mentre per l'istituzione Altro ho estratto l'elenco completo dei Rettori delle principali Università italiane dal sito del CRUI (Conferenza Rettori Università Italiane).

Allego a video, come esempio, lo script utilizzato per la Camera dei Deputati (gli altri sono in allegato nella directory di Github)

```python

import requests
from bs4 import BeautifulSoup

base_url = "https://www.camera.it"
list_details = "/leg19/48"
list_url = base_url+list_details
print(list_url)

req = requests.get(list_url)
print(req.text)
soup = BeautifulSoup(req.text)

commissioni = soup.find_all("ul", class_="tab_text_ul")

titles_list = []
hrefs_list = []

for commission in commissioni:
    links = commission.find_all('a')
    for link in links:
        title = link.get('title')
        href = link.get('href')
        titles_list.append(title)
        hrefs_list.append(href)

url2 = "https://www.camera.it/leg19/"
hrefs_list = [url2 + href for href in hrefs_list]

import re

# Lista per i titoli modificati
modified_titles_list = []

# Espressione regolare per estrarre il testo tra parentesi
parentheses_regex = re.compile(r'\((.*?)\)')

# Itera sui titoli originali e estrai il testo tra parentesi
for title in titles_list:
    match = parentheses_regex.search(title)
    if match:
        modified_titles_list.append(match.group(1))

# Lista per i titoli modificati con la prima lettera di ogni parola maiuscola
formatted_titles_list = []

# Itera sui titoli modificati e applica la formattazione
for title in modified_titles_list:
    formatted_title = title.title()
    formatted_titles_list.append(formatted_title)

titles_list = formatted_titles_list

import pandas as pd
Uffici = pd.DataFrame({'Ufficio': titles_list, 'Link': hrefs_list})
Uffici['Direzione'] = 'Camera dei Deputati'
Uffici = Uffici[['Direzione', 'Ufficio', 'Link']]

new_links = []

for href in hrefs_list:
    record_req = requests.get(href)
    record_soup = BeautifulSoup(record_req.text, 'html.parser')
    composizione_link = record_soup.find('a', title='Composizione')
    if composizione_link:
        composizione_href = composizione_link.get('href')
        new_link = url2 + composizione_href
        new_links.append(new_link)
    else:
        new_links.append(None)

Uffici['Link_2'] = new_links
pd.set_option('display.max_colwidth', None)

data_dicts = []

for link in Uffici['Link_2']:
    if link:
        req = requests.get(link)
        soup = BeautifulSoup(req.text, 'html.parser')
        riferimenti = [element.find('a').text.strip() for element in soup.find_all(class_='fn')]
        partiti = [element.find('a').text.strip() for element in soup.find_all(class_='org')]
        foto_urls = [element.find('img')['src'] if element.find('img') else None for element in soup.find_all(class_='has_foto')]
        
        for riferimento, partito, foto_url in zip(riferimenti, partiti, foto_urls):
            data_dict = {
                'Link_2': link,
                'Riferimento': riferimento,
                'Partito': partito,
                'Foto': foto_url
            }
            data_dicts.append(data_dict)
    else: 
        data_dict = {
            'Link_2': None,
            'Riferimento': None,
            'Partito': None,
            'Foto': None
        }
        data_dicts.append(data_dict)
        
Riferimenti = pd.DataFrame(data_dicts)

Uffici_full = pd.merge(Riferimenti, Uffici, on='Link_2', how='left')
Uffici_full = Uffici_full.drop(columns=['Link', 'Link_2'])
nuovo_ordine = ['Direzione', 'Ufficio', 'Riferimento', 'Partito', 'Foto']
Uffici_full = Uffici_full.reindex(columns=nuovo_ordine)

Uffici_full.to_csv('camera.csv', index=False)
```

Unificazione dei file .csv delle varie istituzioni in un unico dataframe

``` python
import pandas as pd

parlamento_italiano_link = "parlamento_italiano.csv"
parlamento_italiano = pd.read_csv(parlamento_italiano_link)
governo_italiano_link = "governo_italiano.csv"
governo_italiano = pd.read_csv(governo_italiano_link)
parlamento_europeo_link = "parlamento_europeo.csv"
parlamento_europeo = pd.read_csv(parlamento_europeo_link)
private_link = "private.csv"
private = pd.read_csv(private_link)
altro_link = "altro.csv"
altro = pd.read_csv(altro_link)

Full_Istituzioni = pd.concat([parlamento_italiano, governo_italiano, parlamento_europeo, private, altro], ignore_index=True)
Full_Istituzioni.to_csv('Full_Istituzioni.csv', index=False)
```

Denormalizzazione delle istituzioni

``` python
import pandas as pd

Full_Istituzioni_link = "Full_Istituzioni.csv"
Full_Istituzioni = pd.read_csv(Full_Istituzioni_link)

# Fase di pulizia del dato
Full_Istituzioni['Direzione'] = Full_Istituzioni['Direzione'].str.replace(',', '')
Full_Istituzioni['Ufficio'] = Full_Istituzioni['Ufficio'].str.replace(',', '')
Full_Istituzioni['Partito'] = Full_Istituzioni['Partito'].str.replace(',', '')

def aggiorna_ufficio(row):
    if row['Direzione'] == 'Camera dei Deputati':
        if row['Ufficio'] == 'Difesa':
            return 'Commissione Permanente Difesa della Camera'
        elif row['Ufficio'] == 'Giustizia':
            return 'Commissione Permanente Giustizia della Camera'
    elif row['Direzione'] == 'Ministero della Difesa' and row['Ufficio'] == 'Difesa':
        return 'Ministro della Difesa'
    elif row['Direzione'] == 'Senato della Repubblica' and row['Ufficio'] == 'Giustizia':
        return 'Commissione Permanente Giustizia del Senato'
    elif row['Direzione'] == 'Ministero della Giustizia' and row['Ufficio'] == 'Giustizia':
        return 'Ministro della Giustizia'
    return row['Ufficio']

Full_Istituzioni['Ufficio'] = Full_Istituzioni.apply(aggiorna_ufficio, axis=1)

#Creazione del file DIM_ISTITUZIONI
lista_istituzioni = Full_Istituzioni['Istituzione'].unique().tolist()
ID_Istituzione = [f"{str(i+1)}" for i in range(len(lista_istituzioni))]
dizionario_istituzioni = dict(zip(lista_istituzioni, ID_Istituzione))
DIM_ISTITUZIONI = pd.DataFrame(list(dizionario_istituzioni.items()), columns=['Nome_Istituzione', 'ID_Istituzione'])
nuovo_ordine = ['ID_Istituzione', 'Nome_Istituzione']
DIM_ISTITUZIONI = DIM_ISTITUZIONI.reindex(columns=nuovo_ordine)
DIM_ISTITUZIONI.to_csv('DIM_ISTITUZIONI.csv', index=False)

#Creazione del file DIM_DIREZIONI
direzioni = Full_Istituzioni.iloc[:, :2]
direzioni_2 = direzioni[['Istituzione', 'Direzione']].drop_duplicates()
direzioni_2.rename(columns={'Istituzione': 'Nome_Istituzione'}, inplace=True)
direzioni = pd.merge(direzioni_2, DIM_ISTITUZIONI, on='Nome_Istituzione', how='left')
direzioni.drop('Nome_Istituzione', axis=1, inplace=True)
direzioni.rename(columns={'Direzione': 'Nome_Direzione'}, inplace=True)
ID_Direzione = [f"{str(i+1)}" for i in range(len(direzioni))]
direzioni['ID_Direzione'] = ID_Direzione
nuovo_ordine = ['ID_Direzione', 'Nome_Direzione', 'ID_Istituzione']
direzioni = direzioni.reindex(columns=nuovo_ordine)
direzioni.to_csv('DIM_DIREZIONI.csv', index=False)

#Creazione del file DIM_UFFICI
uffici = Full_Istituzioni.iloc[:, 1:3]
uffici_2 = uffici[['Direzione', 'Ufficio']].drop_duplicates()
uffici_2.rename(columns={'Direzione': 'Nome_Direzione'}, inplace=True)
uffici = pd.merge(uffici_2, direzioni, on='Nome_Direzione', how='left')
uffici.drop(['Nome_Direzione'], axis=1, inplace=True)
uffici.drop(['ID_Istituzione'], axis=1, inplace=True)
uffici.rename(columns={'Ufficio': 'Nome_Ufficio'}, inplace=True)
ID_Ufficio = [f"{str(i+1)}" for i in range(len(uffici))]
uffici['ID_Ufficio'] = ID_Ufficio
nuovo_ordine = ['ID_Ufficio', 'Nome_Ufficio', 'ID_Direzione']
uffici = uffici.reindex(columns=nuovo_ordine)
uffici.to_csv('DIM_UFFICI.csv', index=False)

#Creazione del file DIM_RIFERIMENTI
riferimenti = Full_Istituzioni.iloc[:, 2:6]
riferimenti.rename(columns={'Ufficio': 'Nome_Ufficio'}, inplace=True)
riferimenti = pd.merge(riferimenti, uffici, on='Nome_Ufficio', how='left')
riferimenti.drop(['Nome_Ufficio'], axis=1, inplace=True)
riferimenti.drop(['ID_Direzione'], axis=1, inplace=True)
riferimenti.rename(columns={'Riferimento': 'Nome_Riferimento'}, inplace=True)
ID_Riferimento = [f"{str(i+1)}" for i in range(len(riferimenti))]
riferimenti['ID_Riferimento'] = ID_Riferimento
nuovo_ordine = ['ID_Riferimento', 'Nome_Riferimento', 'Partito', 'Foto', 'ID_Ufficio']
riferimenti = riferimenti.reindex(columns=nuovo_ordine)
riferimenti.to_csv('DIM_RIFERIMENTI.csv', index=False)
``` 
