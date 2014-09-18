#!/bin/sh

#Must be root to run the script
if [ `id -u` != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi


if [ `uname -m` = 'i686' ] ; then 
    URL_LATEST="http://download.cdn.mozilla.net/pub/mozilla.org/thunderbird/releases/latest/linux-i686/en-US/"
else
    URL_LATEST="http://download.cdn.mozilla.net/pub/mozilla.org/thunderbird/releases/latest/linux-x86_64/en-US/"
fi

FILENAME=`wget -q -O - $URL_LATEST | sed -n "/href/ s/.*href=['\"]\([^'\"]*.tar.bz2\)['\"].*/\1/gp"`

wget -P /tmp $URL_LATEST$FILENAME

tar xjvf /tmp/$FILENAME -C /opt
ln -sf /opt/thunderbird/chrome/icons/default/default48.png /usr/share/icons/hicolor/128x128/apps/thunderbird.png
ln -sf /opt/thunderbird/chrome/icons/default/default48.png /usr/share/pixmaps/thunderbird.png

cat <<EOF > /usr/share/applications/thunderbird.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird
Comment=Read your emails
GenericName=MUA
X-GNOME-FullName=Thunderbird
Exec=/opt/thunderbird/thunderbird-bin %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=thunderbird
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=thunderbird-bin
StartupNotify=true
EOF

