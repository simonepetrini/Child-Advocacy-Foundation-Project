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
