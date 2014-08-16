#!/bin/sh

#Must be root to run the script
if [ `id -u` != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi


if [ `uname -m` = 'i686' ] ; then 
    URL_LATEST="http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/latest/linux-i686/en-US/"
else
    URL_LATEST="http://download.cdn.mozilla.net/pub/mozilla.org/firefox/releases/latest/linux-x86_64/en-US/"
fi

FILENAME=`wget -q -O - $URL_LATEST | sed -n "/href/ s/.*href=['\"]\([^'\"]*.tar.bz2\)['\"].*/\1/gp"`

wget -P /tmp $URL_LATEST$FILENAME

tar xjvf /tmp/$FILENAME -C /opt
ln -sf /opt/firefox/browser/icons/mozicon128.png /usr/share/icons/hicolor/128x128/apps/firefox.png
ln -sf /opt/firefox/browser/icons/mozicon128.png /usr/share/pixmaps/firefox.png

cat <<EOF > /usr/share/applications/firefox.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Firefox
Comment=Browse the World Wide Web
GenericName=Web Browser
X-GNOME-FullName=Firefox Web Browser
Exec=/opt/firefox/firefox %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=firefox
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupWMClass=Firefox-bin
StartupNotify=true
EOF

