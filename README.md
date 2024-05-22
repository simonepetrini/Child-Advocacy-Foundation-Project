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
