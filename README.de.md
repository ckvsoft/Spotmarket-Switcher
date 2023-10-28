<p align="center" width="100%">
    <img width="33%" src="https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/SpotmarketSwitcherLogo.png?raw=true"> 
</p>

[Tschechisch](README.cs.md)-[dänisch](README.da.md)-[Deutsch](README.de.md)-[Englisch](README.md)-[Spanisch](README.es.md)-[estnisch](README.et.md)-[finnisch](README.fi.md)-[Französisch](README.fr.md)-[griechisch](README.el.md)-[Italienisch](README.it.md)-[Niederländisch](README.nl.md)-[norwegisch](README.no.md)-[Polieren](README.pl.md)-[Portugiesisch](README.pt.md)-[Schwedisch](README.sv.md)-[japanisch](README.ja.md)

## Willkommen im Spotmarket-Switcher-Repository!

Was macht diese Software?
Dies ist ein Linux-Shell-Skript, das Ihr Batterieladegerät und/oder Ihre schaltbaren Steckdosen zum richtigen Zeitpunkt einschaltet, wenn Ihre stündlichen dynamischen Energiepreise niedrig sind.
Über die Steckdosen können Sie dann deutlich günstiger einen Warmwasserspeicher anschalten oder den Batteriespeicher nachts automatisch aufladen, wenn günstiger Windstrom am Netz verfügbar ist.
Über eine Wetter-API kann der zu erwartende Solarertrag berücksichtigt und Batteriespeicher entsprechend reserviert werden.
Unterstützte Systeme sind derzeit:

-   Shelly-Produkte (wie z[Shelly Plug S](https://shellyparts.de/products/shelly-plus-plug-s)oder[Shelly Plus](https://shellyparts.de/products/shelly-plus-1pm))
-   [AVMFritz!DECT200](https://avm.de/produkte/smart-home/fritzdect-200/)Und[210](https://avm.de/produkte/smart-home/fritzdect-210/)schaltbare Steckdosen
-   [Victron](https://www.victronenergy.com/)Venus OS Energiespeichersysteme wie das[MultiPlus-II-Serie](https://www.victronenergy.com/inverters-chargers)

Der Code ist einfach gehalten, so dass er problemlos an andere Energiespeichersysteme angepasst werden kann, wenn Sie in der Lage sind, den Ladevorgang über Linux-Shell-Befehle zu steuern.
Schauen Sie sich bitte Zeile 965 der controller.sh (charger_command_turnon) an, damit Sie sehen können, wie einfach die Anpassung ist.
Bitte erstellen Sie einen Github-Fork und teilen Sie Ihre Anpassung, damit andere Benutzer davon profitieren können.

## Datenquelle

Die Software nutzt derzeit EPEX Spot-Stundenpreise, die von drei kostenlosen APIs (Tibber, aWATTar und Entso-E) bereitgestellt werden.
Die integrierte kostenlose Entso-E API stellt Energiepreisdaten der folgenden Länder bereit:
Albanien (AL), Österreich (AT), Belgien (BE), Bosnien und Herz. (BA), Bulgarien (BG), Kroatien (HR), Zypern (CY), Tschechische Republik (CZ), Dänemark (DK), Estland (EE), Finnland (FI), Frankreich (FR), Georgien (GE), Deutschland (DE), Griechenland (GR), Ungarn (HU), Irland (IE), Italien (IT), Kosovo (XK), Lettland (LV), Litauen (LT), Luxemburg (LU), Malta (MT), Moldawien (MD), Montenegro (ME), Niederlande (NL), Nordmazedonien (MK), Norwegen (NO), Polen (PL), Portugal (PT), Rumänien (RO), Serbien (RS), Slowakei (SK) , Slowenien (SI), Spanien (ES), Schweden (SE), Schweiz (CH), Türkei (TR), Ukraine (UA), Vereinigtes Königreich (UK) siehe[Transparenz Entso-E-Plattform](https://transparency.entsoe.eu/transmission-domain/r2/dayAheadPrices/show).

![grafik](https://user-images.githubusercontent.com/6513794/224442951-c0155a48-f32b-43f4-8014-d86d60c3b311.png)

## Installation

Das Einrichten des Spotmarket-Switchers ist ein unkomplizierter Vorgang. Wenn Sie bereits einen UNIX-basierten Computer wie macOS, Linux oder Windows mit dem Linux-Subsystem ausführen, befolgen Sie diese Schritte, um die Software zu installieren:

1.  Laden Sie das Installationsskript mithilfe von aus dem GitHub-Repository herunter[dieser Hyperlink](https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh), oder führen Sie den folgenden Befehl in Ihrem Terminal aus:
        wget https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh

2.  Führen Sie das Installationsskript mit zusätzlichen Optionen aus, um alles in einem Unterverzeichnis für Ihre Inspektion vorzubereiten. Zum Beispiel:
        DESTDIR=/tmp/foo sh victron-venus-os-install.sh
    Wenn Sie Victron Venus OS verwenden, sollte das richtige DESTDIR sein`/`(das Stammverzeichnis). Schauen Sie sich gerne die installierten Dateien an`/tmp/foo`.
    Auf einem Cerbo GX ist das Dateisystem schreibgeschützt gemountet. Sehen<https://www.victronenergy.com/live/ccgx:root_access>. Um das Dateisystem beschreibbar zu machen, müssen Sie den folgenden Befehl ausführen, bevor Sie das Installationsskript ausführen:
        /opt/victronenergy/swupdate-scripts/resize2fs.sh

Bitte beachten Sie, dass diese Software derzeit zwar für das Venus-Betriebssystem optimiert ist, aber an andere Linux-Varianten angepasst werden kann, wie Debian/Ubuntu auf einem Raspberry Pi oder einem anderen kleinen Board. Ein Spitzenkandidat ist das sicherlich[OpenWRT](https://www.openwrt.org). Für Testzwecke ist die Verwendung eines Desktop-Rechners in Ordnung, im 24/7-Einsatz ist jedoch der höhere Stromverbrauch besorgniserregend.

### Zugriff auf Venus OS

Anweisungen zum Zugriff auf das Venus-Betriebssystem finden Sie unter<https://www.victronenergy.com/live/ccgx:root_access>.

### Ausführung des Installationsskripts

-   Wenn Sie Victron Venus OS verwenden:
    -   Bearbeiten Sie dann die Variablen mit einem Texteditor in`/data/etc/Spotmarket-Switcher/config.txt`.
    -   Richten Sie einen ESS-Ladeplan ein (siehe Screenshot). Im Beispiel lädt sich der Akku bei Aktivierung nachts bis zu 50 % auf, andere Ladezeiten am Tag werden ignoriert. Falls nicht gewünscht, erstellen Sie einen Zeitplan für alle 24 Stunden des Tages. Denken Sie daran, es nach der Erstellung zu deaktivieren. Stellen Sie sicher, dass die Systemzeit (wie oben rechts auf dem Bildschirm angezeigt) korrekt ist.![grafik](https://user-images.githubusercontent.com/6513794/206877184-b8bf0752-b5d5-4c1b-af15-800b6499cfc7.png)

Der Screenshot zeigt die Konfiguration des automatischen Ladens zu benutzerdefinierten Zeiten. Standardmäßig deaktiviert, kann vom Skript vorübergehend aktiviert werden.

-   Anleitung zur Installation des Spotmarket-Switcher auf einem Windows 10- oder 11-System zum Testen ohne Victron-Geräte (nur schaltbare Steckdosen).

    -   Start`cmd.exe`als Administrator
    -   Eingeben`wsl --install -d Debian`
    -   Geben Sie einen neuen Benutzernamen ein, z`admin`
    -   Geben Sie ein neues Kennwort ein
    -   Eingeben`sudo su`und geben Sie Ihr Passwort ein
    -   Eingeben`apt-get update && apt-get install wget curl`
    -   Fahren Sie mit der manuellen Linux-Beschreibung unten fort (das Installationsskript ist nicht kompatibel).
    -   Vergessen Sie nicht, dass Windows das System stoppt, wenn Sie die Shell schließen.


-   Wenn Sie ein Linux-System wie Ubuntu oder Debian verwenden:
    -   Kopieren Sie das Shell-Skript (`controller.sh`) an einen benutzerdefinierten Speicherort und passen Sie die Variablen entsprechend Ihren Anforderungen an.
    -   Die Befehle sind`cd /path/to/save/ && curl -s -O "https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/scripts/{controller.sh,sample.config.txt}" && chmod +x ./controller.sh && mv sample.config.txt config.txt`und zum Bearbeiten Ihrer Einstellungen verwenden Sie`vi /path/to/save/config.txt`
    -   Erstellen Sie eine Crontab oder eine andere Planungsmethode, um dieses Skript zu Beginn jeder Stunde auszuführen.
    -   Beispiel-Crontab:
          Verwenden Sie den folgenden Crontab-Eintrag, um das Steuerskript stündlich auszuführen:
          Öffnen Sie Ihr Terminal und betreten Sie es`crontab -e`, dann fügen Sie die folgende Zeile ein:`0 * * * * /path/to/controller.sh`

### Unterstützung und Beitrag :+1:

Wenn Sie dieses Projekt wertvoll finden, denken Sie bitte darüber nach, die weitere Entwicklung über diese Links zu sponsern und zu unterstützen:

-   [Revolut](https://revolut.me/christqki2)
-   [PayPal](https://paypal.me/christian1980nrw)

Wenn Sie aus Deutschland kommen und an einem Wechsel zu einem dynamischen Stromtarif interessiert sind, können Sie das Projekt unterstützen, indem Sie sich hier anmelden[Tibber (Empfehlungslink)](https://invite.tibber.com/ojgfbx2e)oder durch Eingabe des Codes`ojgfbx2e`in Ihrer App. Sowohl Sie als auch das Projekt erhalten**50 Euro Bonus für Hardware**. Bitte beachten Sie, dass für einen Stundentarif ein Smart Meter oder ein Pulse-IR erforderlich ist (<https://tibber.com/de/store/produkt/pulse-ir>).
Wenn Sie einen Erdgastarif benötigen oder einen klassischen Stromtarif bevorzugen, können Sie das Projekt trotzdem unterstützen[Octopus Energy (Empfehlungslink)](https://share.octopusenergy.de/glass-raven-58).
Sie erhalten einen Bonus (das Angebot variiert**zwischen 50 und 120 Euro**) für sich selbst und auch für das Projekt.
Octopus hat den Vorteil, dass einige Angebote ohne Mindestvertragslaufzeit sind. Sie eignen sich beispielsweise ideal, um einen an Börsenkursen orientierten Tarif zu pausieren.

Wenn Sie aus Österreich kommen, können Sie uns mit unterstützen[aWATTar Österreich (Referenzlink)](https://www.awattar.at/services/offers/promotecustomers). Bitte nutzen Sie`3KEHMQN2F`als Code.

## Haftungsausschluss

Bitte beachten Sie die Nutzungsbedingungen unter<https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/License.md>
