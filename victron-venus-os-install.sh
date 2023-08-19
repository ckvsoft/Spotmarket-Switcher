#!/bin/sh

License=$(cat <<EOLICENSE
MIT License

Copyright (c) 2023 christian1980nrw

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOLICENSE
)

set -e

if [ -z "$LANG" ]; then
  export LANG=C
fi

if [ "-h" = "$1" ] || [ "--help" = "$1" ]; then
  if echo "$LANG" | grep -qi "^de" ; then
    cat <<EOHILFE
Optionen

 -h | --help - Zeigt diese Hilfe

Lizenz

$(echo "$License" | sed -e 's/^/  /')

Autor

  Christian
EOHILFE
  else
    cat <<EOHELP

Description

Options

 -h | --help - Shows this help.

License

$(echo "$License" | sed -e 's/^/  /')

Author

  Christian
EOHELP
  fi
fi

# DESTDIR is optionally set as an environment variable.
if [ -n "$DESTDIR" ] && [ "/" != "$DESTDIR" ] ; then
    if which realpath > /dev/null; then
        RESOLVED_DESTDIR=$(realpath "$DESTDIR")
        if [ "$RESOLVED_DESTDIR" != "$DESTDIR" ]; then
            echo "W: The provided installation path ($DESTDIR) is a symbolic link that points to $RESOLVED_DESTDIR."
            echo "   The script will use the resolved path for installation."
        fi
        DESTDIR="$RESOLVED_DESTDIR"
    else
        if ! echo "$DESTDIR" | grep -q "^/"; then
            echo "E: The DESTDIR passed from environment variable must be absolute or realpath must be available."
            exit 1
        fi
    fi
    echo
    echo "W: The environment variable DESTDIR is set to the value '$DESTDIR' that is different from '/', the root directory."
    echo "   This is meant to support testing and packaging, not for a true installation."
    echo "   If you are using Victron Venus OS, the correct installation directory should be  '/'."
    echo "   No harm is expected to be caused, you anyway have 5 seconds to cancel now with CTRL-C."
    sleep 5
    echo "I: Will now continue. Still, you can interrupt at any time."
    echo
fi

if ! mkdir -p "$DESTDIR"/data/etc/Spotmarket-Switcher/service ; then
    echo "E: Could not create service directory '$DESTDIR/data/etc/Spotmarket-Switcher/service'."
    exit 1
fi

wgetOptions="--no-verbose --continue --no-directories --show-progress"
cd "$DESTDIR"/data/etc/Spotmarket-Switcher

for url in \
    https://raw.githubusercontent.com/christian1980nrw/Victron-ESS__AVM-Fritz-DECT200-210__Spotmarket-Switcher/main/victron-venus-os-install.sh \
    https://raw.githubusercontent.com/christian1980nrw/Victron-ESS__AVM-Fritz-DECT200-210__Spotmarket-Switcher/main/data/etc/Spotmarket-Switcher/controller.sh
do
    echo "I: Downloading '$(basename "$url")'"
    # This ShellCheck directive only applies to this function to correct wget false positive
    # shellcheck disable=SC2086
    SC_Exclude_1() {
    if ! wget $wgetOptions $url; then
        echo "E: Download of '$(basename "$url")' failed."
        exit 1
    fi
    }
    SC_Exclude_1
done

chmod +x ./controller.sh

url=https://raw.githubusercontent.com/christian1980nrw/Victron-ESS__AVM-Fritz-DECT200-210__Spotmarket-Switcher/main/data/etc/Spotmarket-Switcher/service/run
echo "I: Downloading 'run' script to service subdirectory"
cd service
# This ShellCheck directive only applies to this function to correct wget false positive
# shellcheck disable=SC2086
SC_Exclude_2() {
if ! wget $wgetOptions $url; then
  echo "E: Failure downloading run script from '$url'."
  exit 1
fi
}
SC_Exclude_2
chmod +x ./run

# $DESTDIR is always an absolut path
if [ ! -d "$DESTDIR"/service ]; then
    if [ -n "$DESTDIR" ] && [ "/" != "$DESTDIR" ] ; then
        echo "I: The '$DESTDIR/service' directory is not existing, as expected because of the custom DESTDIR setting."
        echo "   Skipping creation of symbolic link to the Sportmarket-Switcher to register this service."
    else
        echo "W: The '$DESTDIR/service' directory is not existing."
        echo "   Not installing a symbolic link to the Sportmarket-Switcher to register this service."
        echo "   Check on https://github.com/christian1980nrw/Victron-ESS__Shelly-Plug-S__AVM-Fritz-DECT200-210__Spotmarket-Switcher/issues if that has already been reported."
    fi
else
    if [ ! -L "$DESTDIR"/service/Spotmarket-Switcher ]; then
        ln -s "$DESTDIR"/data/etc/Spotmarket-Switcher/service "$DESTDIR"/service/Spotmarket-Switcher
    fi
fi

if [ -e "$DESTDIR"/data/rc.local ]; then
    if grep -q "Spotmarket-Switcher/service /service/Spotmarket-Switcher" "$DESTDIR"/data/rc.local; then
        echo "I: Spotmarket-Switcher/service is already known to rc.local boot script - not added again."
    else
        echo "I: Adding link to Spotmarket-Switcher/service to rc.local boot script."
        echo "ln -s /data/etc/Spotmarket-Switcher/service /service/Spotmarket-Switcher" >> "$DESTDIR"/data/rc.local
    fi
else
    echo "I: Creating new data/rc.local boot script"
    echo "ln -s /data/etc/Spotmarket-Switcher/service /service/Spotmarket-Switcher" > "$DESTDIR"/data/rc.local
    chmod +x "$DESTDIR"/data/rc.local
fi

echo
echo "Installation completed. Spotmarket-Switcher will be executed every full hour."
echo "The crontab will be changed automatically by the script '$DESTDIR/data/etc/Spotmarket-Switcher/service/run' ."
echo "Please edit the configuration file with a text editor, like"
echo "  vi '$DESTDIR/data/etc/Spotmarket-Switcher/controller.sh'"
echo "and change it to your needs."
echo
echo "Note: This installation will survive a Venus OS firmware update."
echo "      Please do an extra reboot after every firmware update so that the crontab can be recreated automatically."
echo
if [ -n "$DESTDIR" ] && [ "/" != "$DESTDIR" ] ; then
    echo "I: Not auto-rebooting now since DESTDIR set to a value != '/'."
    exit 0
elif [ -d /host ]; then
    echo "I: Not auto-rebooting since /host exists, suggesting execution within docker"
    exit 0
else
    echo "The System will reboot in 20 seconds to finalize the setup."
    sleep 20
    if [ -z "$NO_REBOOT" ]; then
      reboot
    fi
fi
