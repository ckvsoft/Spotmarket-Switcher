<p align="center" width="100%">
    <img width="33%" src="https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/SpotmarketSwitcherLogo.png?raw=true"> 
</p>

[Čeština ](README.cs.md) - [Dansk ](README.da.md) - [Deutsch ](README.de.md) - [English ](README.md) - [Español ](README.es.md) - [Estonian ](README.et.md) - [Finnish ](README.fi.md) - [Français ](README.fr.md) - [Greek ](README.el.md) - [Italian ](README.it.md) - [Nederlands ](README.nl.md) - [Norsk ](README.no.md) - [Polski ](README.pl.md) - [Portuguese ](README.pt.md) - [Svenska ](README.sv.md) - [日本語 ](README.ja.md)
## Welcome to the Spotmarket-Switcher repository!

What is this software doing? 
This is a Linux shell script and turning on your battery charger and / or switchable sockets at the right time if your hourly based dynamic energy prices are low.
You can then use the sockets to turn on a hot water tank much more cheaply or you can automatically charge the battery storage at night when cheap wind energy is available on the grid.
The expected solar yield can be taken into account via a weather API and battery storage reserved accordingly.
Supported systems are currently:

- Shelly products (such as [Shelly Plug S](https://shellyparts.de/products/shelly-plus-plug-s) or [Shelly Plus](https://shellyparts.de/products/shelly-plus-1pm))
- [AVMFritz!DECT200](https://avm.de/produkte/smart-home/fritzdect-200/) and [210](https://avm.de/produkte/smart-home/fritzdect-210/) switchable sockets
- [Victron](https://www.victronenergy.com/) Venus OS Energy Storage Systems like the [MultiPlus-II series](https://www.victronenergy.com/inverters-chargers)
  
The code is simple so that it can easily be adapted to other energy storage systems if you are able to control charging by Linux shell commands.
Please have a look around line 965 of the controller.sh (charger_command_turnon) so that you can see how easy it can be adapted.
Please create a github fork and share your customization so other users can benefit from it.

## Data Source

The software currently utilizes EPEX Spot hourly prices provided by three free APIs (Tibber, aWATTar & Entso-E).
The integrated free Entso-E API is providing energy-price-data of the folowing countrys:
Albania (AL), Austria (AT), Belgium (BE), Bosnia and Herz. (BA), Bulgaria (BG), Croatia (HR), Cyprus (CY), Czech Republic (CZ), Denmark (DK), Estonia (EE), Finland (FI), France (FR), Georgia (GE), Germany (DE), Greece (GR), Hungary (HU), Ireland (IE), Italy (IT), Kosovo (XK), Latvia (LV), Lithuania (LT), Luxembourg (LU), Malta (MT), Moldova (MD), Montenegro (ME), Netherlands (NL), North Macedonia (MK), Norway (NO), Poland (PL), Portugal (PT), Romania (RO), Serbia (RS), Slovakia (SK), Slovenia (SI), Spain (ES), Sweden (SE), Switzerland (CH), Turkey (TR), Ukraine (UA), United Kingdom (UK) see [Transparency Entso-E Platform](https://transparency.entsoe.eu/transmission-domain/r2/dayAheadPrices/show). 

![grafik](https://user-images.githubusercontent.com/6513794/224442951-c0155a48-f32b-43f4-8014-d86d60c3b311.png)

## Installation

Setting up the Spotmarket-Switcher is a straightforward process. If you are already running a UNIX-based machine, such as macOS, Linux, or Windows with the Linux subsystem, follow these steps to install the software:


1. Download the install script from the GitHub repository by using [this hyperlink](https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh), or execute the following command in your terminal:
   ```
   wget https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/victron-venus-os-install.sh
   ```

2. Run the installer script with additional options to prepare everything in a subdirectory for your inspection. For example:
   ```
   DESTDIR=/tmp/foo sh victron-venus-os-install.sh
   ```
   If you're using Victron Venus OS, the correct DESTDIR should be `/` (the root directory). Feel free to explore the installed files in `/tmp/foo`.
   On a Cerbo GX the filesystem is mounted read only. See [https://www.victronenergy.com/live/ccgx:root_access](https://www.victronenergy.com/live/ccgx:root_access). In order to make the filesystem writeable you need to execute the following command before running the install script:
   ```
   /opt/victronenergy/swupdate-scripts/resize2fs.sh
   ```

Please note that while this software is currently optimized for the Venus OS, it can be adapted to other Linux flavors, like Debian/Ubuntu on a Raspberry Pi or another small board. A prime candidate is certainly [OpenWRT](https://www.openwrt.org). Using a desktop machine is fine for testing purposes but when in 24/7 use its larger power consumption is of concern.

### Access to Venus OS

For instructions on accessing the Venus OS, please refer to [https://www.victronenergy.com/live/ccgx:root_access](https://www.victronenergy.com/live/ccgx:root_access).

### Execution of the Install Script

- If you're using Victron Venus OS:
  - Then edit the variables with a text editor in `/data/etc/Spotmarket-Switcher/config.txt`.
  - Set up an ESS charge schedule (refer to the screenshot provided). In the example, the battery charges at night up to 50% if activated, other charging times of the day are ignored. If not desired, create a schedule for all 24 hours of the day. Remember to deactivate it after creation. Verify that the system time (as shown in the top-right of the screen) is accurate.
![grafik](https://user-images.githubusercontent.com/6513794/206877184-b8bf0752-b5d5-4c1b-af15-800b6499cfc7.png)

The Screenshot is showing the configuration of automated charging during user defined times. Deactivated by default, may be temporarily activated by the script.

- Instructions to install the Spotmarket-Switcher on a Windows 10 or 11 system for testing without Victron devices (only switchable sockets).

  - launch `cmd.exe` as Administrator
  - Enter `wsl --install -d Debian`
  - Enter a new username like `admin`
  - Enter a new password
  - Enter `sudo su` and type your password
  - Enter `apt-get update && apt-get install wget curl`
  - Continue with the manual Linux description below (installer script is not compatible).
  - Dont forget if you close the shell, Windows will stop the system.
 

- If you're using a Linux-System like Ubuntu or Debian:
  - Copy the shell script (`controller.sh`) to a custom location and adjust the variables according to your needs.
  - the commands are `cd /path/to/save/ && curl -s -O "https://raw.githubusercontent.com/christian1980nrw/Spotmarket-Switcher/main/scripts/{controller.sh,sample.config.txt}" && chmod +x ./controller.sh && mv sample.config.txt config.txt` and to edit your settings use `vi /path/to/save/config.txt`
  - Create a crontab or another scheduling method to run this script at the start of each hour.
  - Sample Crontab:
      Use the following crontab entry to execute the control script every hour:
      Open your terminal and enter `crontab -e`, then insert the following line:
      `0 * * * * /path/to/controller.sh`


### Support and Contribution :+1:

If you find this project valuable, please consider sponsoring and supporting further development through these links:
- [Revolut](https://revolut.me/christqki2)
- [PayPal](https://paypal.me/christian1980nrw)

If you are from Germany and interested in switching to a dynamic electricity tariff, you can support the project by signing up using this [Tibber (referral link)](https://invite.tibber.com/ojgfbx2e) or by entering the code `ojgfbx2e` in your app. Both you and the project will receive **50 euro bonus for hardware**. Please note that a smart meter or a Pulse-IR is required for an hourly tariff (https://tibber.com/de/store/produkt/pulse-ir) .
If you need a natural gas tariff or prefer a classic electricity tariff, you can still support the project [Octopus Energy (referral link)](https://share.octopusenergy.de/glass-raven-58) .
You receive a bonus (the offer varies **between 50 and 120 euro**) for yourself and also for the project.
Octopus has the advantage that some offers are without minimum contract term. They are ideal, for example, for pausing a tariff based on stock exchange prices.

If you are from Austria you can support us by using [aWATTar Austria (referral link)](https://www.awattar.at/services/offers/promotecustomers). Please make use of `3KEHMQN2F` as code.

## Disclaimer
Please note the terms of use at https://github.com/christian1980nrw/Spotmarket-Switcher/blob/main/License.md
