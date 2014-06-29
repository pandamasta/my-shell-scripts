#!/bin/sh
# <Aurelien Martin> 01aurelien@gmail.com
# Bootstrap script that is run onces after the first installation
# The purpose is to setup a pkg repository and install salt-minion that
# will do the rest of the job.
# Tested on FreeBSD 10.0 RELEASE
# pkg = 1.2.7_3
# pystalt =
PKG_REPO="http://poudriere30/10i386-default/"
SALT_MASTER="salt30"
REPO_DIR="/usr/local/etc/pkg/repos"

# Setup default pkg.conf ------------------------------------------------------
if [ ! -f /usr/local/etc/pkg.conf ] ; then
	echo "[INFO] /usr/local/etc/pkg.conf doesn't exist. Creating ..."
	cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg
else
	echo "[INFO] /usr/local/etc/pkg.conf already exist"
fi


# Disable de default FreeBSD repository ----------------------------------------
if grep "enabled: yes" /etc/pkg/FreeBSD.conf; then
	echo "[INFO] Disable the default FreeBSD repository /etc/pkg/FreeBSD.conf"
	sed -i .bak 's/enabled: yes/enabled: no/' /etc/pkg/FreeBSD.conf
else
	echo "[INFO] Default FreeBSD repository is already disable in /etc/pkg/FreeBSD.conf"
fi


#Add the poudriere30 repository ------------------------------------------------

if [ -f $REPO_DIR/poudriere30.conf  ] ; then 
	echo "[INFO] poudriere30.conf already present in $REPO_DIR"
else
	echo "[INFO] poudriere30.conf doesn't exist in $REPO_DIR. Creating ..."
	echo "
poudriere30: {
  url: "pkg+http://poudriere30/10i386-default",
  mirror_type: "srv",
  enabled: yes
}
" > $REPO_DIR/poudriere30.conf 	

fi

#Check if pkg is installed --------------------------------------------------------
if pkg -N >/dev/null 2>&1 ; then
	echo "[INFO] pkg is installed"
else
	echo "[INFO] pkg is not installed"
	# "yes | pkg" for the first setup doesn't work
	pkg -v
fi

#Install pysalt -------------------------------------------------------------------

if pkg info sysutils/py-salt >/dev/null 2>&1 ; then
	echo "[INFO] sysutils/py-salt is already installed"
else
	echo "[INFO] Insatll sysutils/py-salt from poudriere30"
	pkg install -y sysutils/py-salt > bootstrap.log
fi

#Enable salt_minion in rc.conf ----------------------------------------------------
if grep "salt_minion_enable="YES"" /etc/rc.conf >/dev/null 2>&1; then
        echo "[INFO] salt_minion already declared in /etc/rc.conf"
else
        echo "[INFO] Add salt_minion_enable=\"YES\" to /etc/rc.conf"
	echo "salt_minion_enable="YES"" >> /etc/rc.conf
fi

#Setup the default salt master -----------------------------------------------------
if [ -f /usr/local/etc/salt/minion  ] ; then
	echo "[INFO] default minion conf is present"
else
	echo "[INFO] default minion conf not present. Copy from the sample"
	cp /usr/local/etc/salt/minion.sample /usr/local/etc/salt/minion
fi

echo "[INFO] Replace the default master to salt30 in /usr/local/etc/salt/minion"
sed -i .bak "s/#master: salt/master: $salt_master/" /usr/local/etc/salt/minion


#Start the service 
service salt_minion start
