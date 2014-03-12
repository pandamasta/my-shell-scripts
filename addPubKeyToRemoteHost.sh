#!/usr/local/bin/bash
#autor: 01aurelien@gmail.com
#desc:  copy user pubkey to a remote host
#date:  v1  2012/07/26
#       git 2014/03/12
#Tested on FreeBSD 10.0
#TODO: Need to be write in pure sh and setup

localUser=$1
remoteHost=$2
nameOfKey="id_rsa"

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo " ./addUserToRemoteHost [localuser] [address_remote_host]"
    exit 1
fi

#Must be root to run the script
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

#Check if local User (on adm) exist
id -u $localUser
if [ "$?" = "1" ]; then
        echo "User does not exist"
	exit 1
fi


#Set the homedirectory of local user
if [ $localUser == "root" ]; then
	HOMEDIR="/root"
else
	HOMEDIR="/home/$localUser"
fi

#Create the keys if user does not have
if [  ! -f "$HOMEDIR/.ssh/id_rsa.pub" ] ;then
	mkdir -p $HOMEDIR/.ssh
	echo "[INFO] Key not present -- Creating the key with ssh-keygen"
	ssh-keygen -t rsa -C "root@$HOSTNAME" -f $HOMEDIR/.ssh/$nameOfKey

	echo "[INFO] Set right"
	chown -R $localUser:$localUser $HOMEDIR/.ssh && chmod 700 $HOMEDIR/.ssh

	echo "[INFO] Key of the user $localUser"
	ls -l $HOMEDIR/.ssh

else
	echo "[INFO] Key already present"
fi

#FIXME
#Check if the key is already present on the remote host
userPubKey=$(cat $HOMEDIR/.ssh/$nameOfKey)
#Copy the local public key to remote

echo "[INFO] Copy the key on the remote host" 
cat $HOMEDIR/.ssh/$nameOfKey.pub | ssh root@$remoteHost "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"


