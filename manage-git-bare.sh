#!/usr/local/bin/bash
#autor:01aurelien@gmail.com
#desc: Manage local GIT --bare repository
#date: v1 2014/03/04
#
#Tested on FreeBSD 10.0 / Please change the shebang path if you are on other OS

#Must be root to run the script
if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
fi

function usage()
{
cat << EOF
usage: $0 [-c -r -l -s]  reponame.git

Create/Remove local GIT --bare  repository 

   -c          Create a GIT repo 
   -r          Remove a GIT repo. No BACKUP !
   -l          List GIT repo.
   -s [all]    Set the owner/right of a repo on whole repo'

EOF
}

if [ $# == 0 ] ; then
    usage
    exit 1;
fi


GIT_USER="git"
PATH_REPO="/git/base"

function isRepo () { #$1=Absolute repository path   
    if [ -d $1 ] ;then 
        echo "[INFO] Project exist"
        return 0
    else
        echo "[INFO] Project doesn't exist"
        return 1
        
    fi
}

function createGitRepo () { #$1=Absolute path of the project / $2=GIT user  
    mkdir $1
    if [ $? != 0 ]; then echo "[ERROR] Directory $1 cannot be created";fi
    echo "[INFO] Creation of git bare repo" 
        cd $1 && git init --bare --shared 
    echo "[INFO] Setup the right on $1 as $2"  
        chown -R $2:$2 $1
        chmod -R 775 $1 

}

function removeGitRepo () { #$1=Absolute repo path 
    echo "[INFO] Remove $1"
    read -p "Are you sure? " -n 1 -r
    echo   
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -R $1
    fi
}

function listRepo () {

    for i in $(ls /git/base ); do echo ${i%%/}; done

}

function setRight () { #$1=GIT USER / $2=Absolute repo path
  echo "[INFO] Set $2 as $1:$1 775"    
  chown -R $1:$1 $2
  chmod -R 775 $2

}

while getopts "c:r:s:lh" opt; do
    case $opt in
        c)  
            REPO_NAME=$OPTARG
            PATH_PROJECT=$PATH_REPO/$REPO_NAME
            
            isRepo $PATH_PROJECT
            if [ $?  == 0 ] ; then
                echo "[INFO] Please choose a different name"
                exit 1;
            else
                echo "[INFO] Create repository $REPO_NAME in $PATH_PROJECT" 
                createGitRepo $PATH_PROJECT $GIT_USER
            fi
        ;;
        r)

            REPO_NAME=$OPTARG
            PATH_PROJECT=$PATH_REPO/$REPO_NAME
            
            isRepo $PATH_PROJECT 
            if [ $? == 1 ]; then exit 1;fi
            removeGitRepo $PATH_PROJECT
        ;;
        l)
            listRepo
           ;; 

        s)
            REPO_NAME=$OPTARG
            if [ $REPO_NAME = all ];then
                setRight $GIT_USER $PATH_REPO 
            else

                PATH_PROJECT=$PATH_REPO/$REPO_NAME
                isRepo $PATH_PROJECT 
                if [ $? == 1 ]; then exit 1;fi
                setRight $GIT_USER $PATH_PROJECT
            fi
         ;;  
        h)  
           
            usage $OPTARG
        ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
        ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
        ;;
    esac
done

