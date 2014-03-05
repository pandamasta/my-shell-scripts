#!/bin/sh
#autor: 01aurelien@gmail.com
#desc:  Bootstrap a kohana 3.3 working directory from GITHUB  
#date:  v1 2014/03/05
#
#Tested on FreeBSD 10.0 
#http://kohanaframework.org/3.3/guide/kohana/tutorials/git

KO_VERSION="3.3"

if [ ! -d .git ]; then
    echo "[INFO] Creation of GIT repo"
    git init
else
    echo "[INFO] It's a GIT repo"
fi

#
#Get Koahana base 
#
git submodule add git://github.com/kohana/core.git system
git submodule init
git commit -m 'Added initial system directory'

#
#Module -  https://github.com/kohana/kohana/tree/3.3/master/modules
#Available modules: auth cache codebench database image minion orm unittest userguide
#

set -- auth cache codebench database image minion orm unittest userguide
while [ $# -gt 0 ]
do
        git submodule add git://github.com/kohana/$1\.git modules/$1
        echo $1
        shift;
done

git submodule init
git commit -m 'Added wished modules'

#
#Create the working tree
#
mkdir -p application/classes/{Controller,Model}
mkdir -p application/{config,views}
mkdir -p application/{cache,logs}

touch application/classes/{Controller,Model}/.gitignore
touch application/{config,views}/.gitignore
touch application/{cache,logs}/.gitignore

#fetching the index.php and the bootstrap.php
if [ `uname` = "FreeBSD" ] ;then 
    fetch https://github.com/kohana/kohana/raw/"$KO_VERSION"/master/index.php 
    fetch -o application/bootstrap.php https://github.com/kohana/kohana/raw/"$KO_VERSION"/master/application/bootstrap.php
else
    wget https://github.com/kohana/kohana/raw/"$KO_VERSION"/master/index.php --no-check-certificate
    wget https://github.com/kohana/kohana/raw/"$KO_VERSION"/master/application/bootstrap.php --no-check-certificate -O application/bootstrap.php
fi

git add application/ index.php 
git commit -m 'Added initial directory structure'

echo "[INFO]Please remove $0"
