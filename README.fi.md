<p align="center" width="100%">
    <img width="33%" src="https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/SpotmarketSwitcherLogo.png?raw=true"> 
</p>

[Tšekki](README.cs.md)-[Tanskan kieli](README.da.md)-[Saksan kieli](README.de.md)-[Englanti](README.md)-[Espanja](README.es.md)-[Virolainen](README.et.md)-[Finnish](README.fi.md)-[Ranskan kieli](README.fr.md)-[kreikkalainen](README.el.md)-[italialainen](README.it.md)-[Hollannin kieli](README.nl.md)-[Norjan kieli](README.no.md)-[Kiillottaa](README.pl.md)-[Portugalin kieli](README.pt.md)-[Ruotsin kieli](README.sv.md)-[japanilainen](README.ja.md)

## Tervetuloa Spotmarket-Switcher-tietovarastoon!

Mitä tämä ohjelmisto tekee?
Tämä on Linux-kuoriskripti ja käynnistää akkulaturisi ja/tai kytkettävät pistorasiat oikeaan aikaan, jos tuntiperusteiset dynaamiset energiahinnat ovat alhaiset.
Voit sitten käyttää pistorasioita kytkeäksesi kuumavesivaraajan päälle paljon halvemmalla tai voit ladata akkuvaraston automaattisesti yöllä, kun verkossa on saatavilla halpaa tuulienergiaa.
Auringon odotettu tuotto voidaan ottaa huomioon sää API:n ja sen mukaisesti varatun akkuvaraston kautta.
Tuetut järjestelmät ovat tällä hetkellä:

-   Shelly-tuotteet (esim[Shelly Plug S](https://shellyparts.de/products/shelly-plus-plug-s)tai[Shelly Plus](https://shellyparts.de/products/shelly-plus-1pm))
-   [AVMFritz!DECT200](https://avm.de/produkte/smart-home/fritzdect-200/)ja[210](https://avm.de/produkte/smart-home/fritzdect-210/)kytkettävät pistorasiat
-   [Victron](https://www.victronenergy.com/)Venus OS -energian varastointijärjestelmät, kuten[MultiPlus-II sarja](https://www.victronenergy.com/inverters-chargers)

Koodi on yksinkertainen, joten se voidaan helposti sovittaa muihin energianvarastointijärjestelmiin, jos pystyt ohjaamaan latausta Linuxin komentotulkkikomennoilla.
Ole hyvä ja katso noin riviä 965 tiedostosta controller.sh (charger_command_turnon), jotta näet kuinka helppoa se voidaan mukauttaa.
Luo github-haarukka ja jaa mukauksesi, jotta muut käyttäjät voivat hyötyä siitä.

## Tietolähde

Ohjelmisto käyttää tällä hetkellä kolmen ilmaisen API:n (Tibber, aWATTar & Entso-E) tarjoamia EPEX Spot -tuntihintoja.
Integroitu ilmainen Entso-E API tarjoaa energian hintatietoja seuraavista maista:
Albania (AL), Itävalta (AT), Belgia (BE), Bosnia ja Herz. (BA), Bulgaria (BG), Kroatia (HR), Kypros (CY), Tšekki (CZ), Tanska (DK), Viro (EE), Suomi (FI), Ranska (FR), Georgia (GE), Saksa (DE), Kreikka (GR), Unkari (HU), Irlanti (IE), Italia (IT), Kosovo (XK), Latvia (LV), Liettua (LT), Luxemburg (LU), Malta (MT), Moldova (MD), Montenegro (ME), Alankomaat (NL), Pohjois-Makedonia (MK), Norja (NO), Puola (PL), Portugali (PT), Romania (RO), Serbia (RS), Slovakia (SK) , Slovenia (SI), Espanja (ES), Ruotsi (SE), Sveitsi (CH), Turkki (TR), Ukraina (UA), Yhdistynyt kuningaskunta (UK) ks.[Transparency Entso-E -alusta](https://transparency.entsoe.eu/transmission-domain/r2/dayAheadPrices/show).

![grafik](https://user-images.githubusercontent.com/6513794/224442951-c0155a48-f32b-43f4-8014-d86d60c3b311.png)

## Asennus

Spotmarket-Switcherin määrittäminen on suoraviivainen prosessi. Jos käytät jo UNIX-pohjaista konetta, kuten macOS, Linux tai Windows, jossa on Linux-alijärjestelmä, asenna ohjelmisto seuraavasti:

1.  Lataa asennusskripti GitHub-arkistosta käyttämällä[tämä hyperlinkki](https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh)tai suorita seuraava komento päätteessäsi:
        wget https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh

2.  Suorita asennuskomentosarja lisäasetuksineen valmistaaksesi kaiken alihakemistossa tarkastusta varten. Esimerkiksi:
        DESTDIR=/tmp/foo sh victron-venus-os-install.sh
    Jos käytät Victron Venus OS -käyttöjärjestelmää, oikean DESTDIR:n pitäisi olla`/`(juurihakemisto). Voit vapaasti tutkia asennettuja tiedostoja`/tmp/foo`.
    Cerbo GX:ssä tiedostojärjestelmä on asennettu vain luku -tilassa. Katso<https://www.victronenergy.com/live/ccgx:root_access>. Jotta tiedostojärjestelmästä tulee kirjoitettava, sinun on suoritettava seuraava komento ennen asennuskomentosarjan suorittamista:
        /opt/victronenergy/swupdate-scripts/resize2fs.sh

Huomaa, että vaikka tämä ohjelmisto on tällä hetkellä optimoitu Venus-käyttöjärjestelmälle, se voidaan mukauttaa muihin Linux-malleihin, kuten Debian/Ubuntu Raspberry Pi:llä tai muulla pienellä levyllä. Ensisijainen ehdokas on varmasti[OpenWRT](https://www.openwrt.org). Pöytäkoneen käyttö on hyvä testaustarkoituksiin, mutta 24/7 käytössä sen suurempi virrankulutus on huolestuttava.

### Pääsy Venus-käyttöjärjestelmään

Katso ohjeet Venus-käyttöjärjestelmän käyttämiseen osoitteesta<https://www.victronenergy.com/live/ccgx:root_access>.

### Asennuskomentosarjan suorittaminen

-   Jos käytät Victron Venus OS:ää:
    -   Muokkaa sitten muuttujia tekstieditorilla`/data/etc/Spotmarket-Switcher/config.txt`.
    -   Aseta ESS-latausaikataulu (katso mukana tulevaa kuvakaappausta). Esimerkissä akku latautuu yöllä jopa 50 %, jos se on aktivoitu, muut vuorokauden latausajat jätetään huomiotta. Jos et halua, luo aikataulu kaikille vuorokauden 24 tunnille. Muista poistaa se käytöstä luomisen jälkeen. Varmista, että järjestelmän aika (kuten näytön oikeassa yläkulmassa näkyy) on oikea.![grafik](https://user-images.githubusercontent.com/6513794/206877184-b8bf0752-b5d5-4c1b-af15-800b6499cfc7.png)

Kuvakaappaus näyttää automaattisen latauksen kokoonpanon käyttäjän määrittäminä aikoina. Oletusarvoisesti poistettu käytöstä, komentosarja voi aktivoida sen tilapäisesti.

-   Ohjeet Spotmarket-Switcherin asentamiseen Windows 10- tai 11-järjestelmään testausta varten ilman Victron-laitteita (vain kytkettävät pistorasiat).

    -   tuoda markkinoille`cmd.exe`järjestelmänvalvojana
    -   Tulla sisään`wsl --install -d Debian`
    -   Kirjoita uusi käyttäjätunnus kuten`admin`
    -   Syötä uusi salasana
    -   Tulla sisään`sudo su`ja kirjoita salasanasi
    -   Tulla sisään`apt-get update && apt-get install wget curl`
    -   Jatka alla olevalla manuaalisella Linux-kuvauksella (asennusohjelma ei ole yhteensopiva).
    -   Muista, että jos suljet kuoren, Windows pysäyttää järjestelmän.


-   Jos käytät Linux-järjestelmää, kuten Ubuntua tai Debiania:
    -   Kopioi komentotulkin komentosarja (`controller.sh`) mukautettuun paikkaan ja säädä muuttujia tarpeidesi mukaan.
    -   komennot ovat`cd /path/to/save/ && curl -s -O "https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/scripts/{controller.sh,sample.config.txt}" && chmod +x ./controller.sh && mv sample.config.txt config.txt`ja muokataksesi asetuksiasi käytä`vi /path/to/save/config.txt`
    -   Luo crontab tai muu ajoitusmenetelmä suorittaaksesi tämän skriptin jokaisen tunnin alussa.
    -   Esimerkki Crontab:
          Käytä seuraavaa crontab-merkintää suorittaaksesi ohjauskomentosarjan tunnin välein:
          Avaa terminaali ja syötä sisään`crontab -e`, lisää sitten seuraava rivi:`0 * * * * /path/to/controller.sh`

### Tuki ja panos :+1:

Jos pidät tätä projektia arvokkaana, harkitse sponsorointia ja jatkokehityksen tukemista näiden linkkien kautta:

-   [Revolut](https://revolut.me/christqki2)
-   [PayPal](https://paypal.me/christian1980nrw)

Jos olet Saksasta ja olet kiinnostunut siirtymään dynaamiseen sähkötariffiin, voit tukea hanketta rekisteröitymällä tällä[Tibber (viittauslinkki)](https://invite.tibber.com/ojgfbx2e)tai syöttämällä koodi`ojgfbx2e`sovelluksessasi. Sekä sinä että projekti saavat**50 euron bonus laitteistolle**. Huomaa, että tuntitariffiin tarvitaan älymittari tai Pulse-IR (<https://tibber.com/de/store/produkt/pulse-ir>) .
Jos tarvitset maakaasutariffia tai haluat klassisen sähkötariffin, voit silti tukea hanketta[Octopus Energy (viittauslinkki)](https://share.octopusenergy.de/glass-raven-58).
Saat bonuksen (tarjous vaihtelee**50-120 euron välillä**) itsellesi ja myös projektille.
Octopusilla on se etu, että osa tarjouksista on ilman vähimmäissopimusta. Ne soveltuvat ihanteellisesti esimerkiksi pörssihintoihin perustuvan tariffin keskeyttämiseen.

Jos olet Itävallasta, voit tukea meitä käyttämällä[aWATtar Itävalta (viittauslinkki)](https://www.awattar.at/services/offers/promotecustomers). Ole hyvä ja käytä`3KEHMQN2F`koodina.

## Vastuuvapauslauseke

Huomioi käyttöehdot osoitteessa<https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/License.md>
