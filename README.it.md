<p align="center" width="100%">
    <img width="33%" src="https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/SpotmarketSwitcherLogo.png?raw=true"> 
</p>

[ceco](README.cs.md)-[danese](README.da.md)-[Tedesco](README.de.md)-[Inglese](README.md) - [spagnolo](README.es.md)-[Estone](README.et.md)-[finlandese](README.fi.md)-[Francese](README.fr.md)-[greco](README.el.md)-[Italiano](README.it.md)-[Olandese](README.nl.md)-[norvegese](README.no.md)-[Polacco](README.pl.md)-[portoghese](README.pt.md)-[svedese](README.sv.md)-[giapponese](README.ja.md)

## Benvenuti nel repository Spotmarket-Switcher!

Cosa sta facendo questo software?
Questo è uno script della shell Linux che accende il caricabatterie e/o le prese commutabili al momento giusto se i prezzi dinamici dell'energia su base oraria sono bassi.
È quindi possibile utilizzare le prese per accendere un serbatoio dell'acqua calda in modo molto più economico oppure caricare automaticamente la batteria di accumulo di notte quando è disponibile energia eolica a basso costo sulla rete.
Il rendimento solare previsto può essere preso in considerazione tramite un'API meteorologica e l'accumulo della batteria riservato di conseguenza.
I sistemi supportati sono attualmente:

-   Prodotti Shelly (come[Shelly Spina S](https://shellyparts.de/products/shelly-plus-plug-s)O[Shelly Plus](https://shellyparts.de/products/shelly-plus-1pm))
-   [AVMFritz!DECT200](https://avm.de/produkte/smart-home/fritzdect-200/)E[210](https://avm.de/produkte/smart-home/fritzdect-210/)prese commutabili
-   [Victron](https://www.victronenergy.com/)I sistemi di accumulo di energia Venus OS come il[Serie MultiPlus-II](https://www.victronenergy.com/inverters-chargers)

The code is simple so that it can easily be adapted to other energy storage systems if you are able to control charging by Linux shell commands.
Please have a look around line 965 of the controller.sh (charger_command_turnon) so that you can see how easy it can be adapted.
Please create a github fork and share your customization so other users can benefit from it.

## Fonte di dati

Il software attualmente utilizza i prezzi orari EPEX Spot forniti da tre API gratuite (Tibber, aWATTar ed Entso-E).
L'API Entso-E gratuita integrata fornisce dati sui prezzi dell'energia dei seguenti paesi:
Albania (AL), Austria (AT), Belgio (BE), Bosnia ed Herz. (BA), Bulgaria (BG), Croazia (HR), Cipro (CY), Repubblica Ceca (CZ), Danimarca (DK), Estonia (EE), Finlandia (FI), Francia (FR), Georgia (GE), Germania (DE), Grecia (GR), Ungheria (HU), Irlanda (IE), Italia (IT), Kosovo (XK), Lettonia (LV), Lituania (LT), Lussemburgo (LU), Malta (MT), Moldavia (MD), Montenegro (ME), Paesi Bassi (NL), Macedonia del Nord (MK), Norvegia (NO), Polonia (PL), Portogallo (PT), Romania (RO), Serbia (RS), Slovacchia (SK) , Slovenia (SI), Spagna (ES), Svezia (SE), Svizzera (CH), Turchia (TR), Ucraina (UA), Regno Unito (UK) vedi[Piattaforma per la trasparenza Entso-E](https://transparency.entsoe.eu/transmission-domain/r2/dayAheadPrices/show).

![grafik](https://user-images.githubusercontent.com/6513794/224442951-c0155a48-f32b-43f4-8014-d86d60c3b311.png)

## Installazione

La configurazione di Spotmarket-Switcher è un processo semplice. Se stai già utilizzando un computer basato su UNIX, come macOS, Linux o Windows con il sottosistema Linux, segui questi passaggi per installare il software:

1.  Scaricare lo script di installazione dal repository GitHub utilizzando[questo collegamento ipertestuale](https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh)oppure esegui il seguente comando nel tuo terminale:
        wget https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh

2.  Run the installer script with additional options to prepare everything in a subdirectory for your inspection. For example:
        DESTDIR=/tmp/foo sh victron-venus-os-install.sh
    Se utilizzi il sistema operativo Victron Venus, la DESTDIR corretta dovrebbe essere`/`(la directory principale). Sentiti libero di esplorare i file installati in`/tmp/foo`.
    Su un Cerbo GX il filesystem è montato in sola lettura. Vedere<https://www.victronenergy.com/live/ccgx:root_access>. Per rendere scrivibile il filesystem è necessario eseguire il seguente comando prima di eseguire lo script di installazione:
        /opt/victronenergy/swupdate-scripts/resize2fs.sh

Tieni presente che sebbene questo software sia attualmente ottimizzato per il sistema operativo Venus, può essere adattato ad altre versioni Linux, come Debian/Ubuntu su un Raspberry Pi o un'altra piccola scheda. Un ottimo candidato lo è certamente[OpenWRT](https://www.openwrt.org). L'uso di una macchina desktop va bene a scopo di test, ma quando viene utilizzato 24 ore su 24, 7 giorni su 7, il suo consumo energetico maggiore è preoccupante.

### Accesso al sistema operativo Venus

Per istruzioni sull'accesso al sistema operativo Venus, fare riferimento a<https://www.victronenergy.com/live/ccgx:root_access>.

### Esecuzione dello script di installazione

-   Se utilizzi il sistema operativo Victron Venus:
    -   Quindi modifica le variabili con un editor di testo in`/data/etc/Spotmarket-Switcher/config.txt`.
    -   Configurare un programma di addebito ESS (fare riferimento allo screenshot fornito). Nell'esempio la batteria si ricarica di notte fino al 50% se attivata, gli altri tempi di ricarica della giornata vengono ignorati. Se non lo desideri, crea una pianificazione per tutte le 24 ore del giorno. Ricordati di disattivarlo dopo la creazione. Verificare che l'ora del sistema (come mostrato nell'angolo in alto a destra dello schermo) sia accurata.![grafik](https://user-images.githubusercontent.com/6513794/206877184-b8bf0752-b5d5-4c1b-af15-800b6499cfc7.png)

Lo screenshot mostra la configurazione della ricarica automatizzata durante gli orari definiti dall'utente. Disattivato per impostazione predefinita, può essere temporaneamente attivato dallo script.

-   Istruzioni per installare lo Spotmarket-Switcher su un sistema Windows 10 o 11 per eseguire test senza dispositivi Victron (solo prese commutabili).

    -   launch `cmd.exe`come amministratore
    -   accedere`wsl --install -d Debian`
    -   Inserisci un nuovo nome utente come`admin`
    -   Inserire una nuova password
    -   accedere`sudo su`e digita la tua password
    -   accedere`apt-get update && apt-get install wget curl`
    -   Continuare con la descrizione manuale di Linux riportata di seguito (lo script di installazione non è compatibile).
    -   Non dimenticare che se chiudi la shell, Windows arresterà il sistema.


-   Se utilizzi un sistema Linux come Ubuntu o Debian:
    -   Copia lo script della shell (`controller.sh`) in una posizione personalizzata e regolare le variabili in base alle proprie esigenze.
    -   i comandi sono`cd /path/to/save/ && curl -s -O "https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/scripts/{controller.sh,sample.config.txt}" && chmod +x ./controller.sh && mv sample.config.txt config.txt`e per modificare le impostazioni utilizzare`vi /path/to/save/config.txt`
    -   Crea un crontab o un altro metodo di pianificazione per eseguire questo script all'inizio di ogni ora.
    -   Crontab di esempio:
          Utilizza la seguente voce crontab per eseguire lo script di controllo ogni ora:
          Apri il tuo terminale ed entra`crontab -e`, quindi inserisci la seguente riga:`0 * * * * /path/to/controller.sh`

### Supporto e contributo :+1:

Se ritieni utile questo progetto, considera la possibilità di sponsorizzare e supportare l'ulteriore sviluppo attraverso questi collegamenti:

-   [Rivoluzione](https://revolut.me/christqki2)
-   [PayPal](https://paypal.me/christian1980nrw)

Se vieni dalla Germania e sei interessato a passare a una tariffa elettrica dinamica, puoi sostenere il progetto iscrivendoti utilizzando questo[Tibber (link di riferimento)](https://invite.tibber.com/ojgfbx2e)oppure inserendo il codice`ojgfbx2e`nella tua app. Riceverete sia tu che il progetto**Bonus di 50 euro per l'hardware**. Si prega di notare che per una tariffa oraria è necessario un contatore intelligente o un Pulse-IR (<https://tibber.com/de/store/produkt/pulse-ir>).
Se hai bisogno di una tariffa per il gas naturale o preferisci una tariffa elettrica classica, puoi comunque sostenere il progetto[Octopus Energy (link di riferimento)](https://share.octopusenergy.de/glass-raven-58) .
You receive a bonus (the offer varies **tra 50 e 120 euro**) per te stesso e anche per il progetto.
Octopus ha il vantaggio che alcune offerte non hanno una durata minima contrattuale. Sono ideali, ad esempio, per sospendere una tariffa basata sui prezzi di borsa.

Se vieni dall'Austria puoi sostenerci utilizzando[aWATTar Austria (link di riferimento)](https://www.awattar.at/services/offers/promotecustomers). Si prega di utilizzare`3KEHMQN2F`come codice.

## Disclaimer

Si prega di notare i termini di utilizzo su<https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/License.md>
