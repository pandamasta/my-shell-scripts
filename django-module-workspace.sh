#!/bin/sh
#
# Copyright (c) 2014 Aurelien Martin 
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# TESTED ON: Debian 7.0
VERSION="0.1"

#TODO: Add the getops in order to support option like path ....

usage()
{
cat << EOF
usage: $0 <nameofmodule>

This script will generate the base directory of a django module like django-<nameofmodule>

It will create files LICENSE MANIFEST.in README.rst setup.py in the root directory
and also the app files models.py admin.py views.py tests.py in a subdirecotry.

EOF
}

if [ $# = 0 ] ; then
    usage
    exit 1;
fi

FILE_LICENSE="LICENSE"
FILE_MANIFEST="MANIFEST.in"
FILE_README="README.rst"
FILE_SETUP="setup.py"

MODULE_PATH=""
MODULE_NAME=$1
MODULE_DIR="django-$1"

setupDir()
{
    if [ ! -d $MODULE_DIR ] ; then 
        mkdir $MODULE_DIR
        echo "-> $MODULE_DIR created"
        if [ $? = 1 ]; then
            echo "*  ERROR - Cannot create $MODULE_DIR directory" ; exit 1;
        fi
        mkdir -p $MODULE_DIR/$MODULE_NAME/templates $MODULE_DIR/$MODULE_NAME/static
    else
        echo "*  ERROR - Directory $i already exist. Choose another name"
    fi
}

setupFile()
{

####################
# setup.py TEMPLATE
####################

cat <<EOF > $MODULE_DIR/$FILE_SETUP
import os
from setuptools import setup

README = open(os.path.join(os.path.dirname(__file__), 'README.rst')).read()

# allow setup.py to be run from any path
os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

setup(
    name='$MODULE_DIR',
    version='0.1',
    packages=['$MODULE_NAME'],
    include_package_data=True,
    license='BSD License',  # example license
    description='A simple Django app to ......',
    long_description=README,
    url='',
    author='',
    author_email='',
    classifiers=[
        'Environment :: Web Environment',
        'Framework :: Django',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License', # example license
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Topic :: Internet :: WWW/HTTP',
        'Topic :: Internet :: WWW/HTTP :: Dynamic Content',
    ],
)
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$FILE_SETUP has been created "
else
    echo "*  ERROR - $MODULE_DIR/$FILE_SETUP has not been created"
fi


####################
# README TEMPLATE
####################

cat <<EOF > $MODULE_DIR/$FILE_README
=====
django-$MODULE_NAME
=====

        [ !! APP NOT FINISH TO BE USED AS EXPECTED !! ]
     [ !! README WILL BE UPDATED WHEN ALL WILL BE READY !! ]


django-$MODULE_NAME is ...


Quick start
-----------


1. Add $MODULE_NAME to your INSTALLED_APPS setting like this

      INSTALLED_APPS = (
          '$MODULE_NAME', 
      )

2. Include the $MODULE_NAME URLconf in your project urls.py like this:

      url(r'^$MODULE_NAME/', include('$MODULE_NAME.urls')),
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$FILE_README has been created "
else
    echo "*  ERROR - $MODULE_DIR/$FILE_SETUP has not been created"
fi

####################
# MANIFEST TEMPLATE
####################

cat <<EOF >$MODULE_DIR/$FILE_MANIFEST
include LICENSE
include README.rst
recursive-include $MODULE_NAME/templates *
recursive-include $MODULE_NAME/static *
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$FILE_MANIFEST has been created "
else
    echo "*  ERROR - $MODULE_DIR/$FILE_MANIFEST has not been created"
fi

####################
# LICENCE TEMPLATE
####################

cat <<EOF >$MODULE_DIR/$FILE_LICENSE
Copyright (c) 2014, <author>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$FILE_LICENSE has been created "
else
    echo "*  ERROR - $FILE_LICENSE has not been created"
fi

}

#
#Create the same file as "django-admin.py startapp xxx"
#

createAppFile() 
{

touch $MODULE_DIR/$MODULE_NAME/__init__.py

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$MODULE_NAME/__init__.py has been created "
else
    echo "*  ERROR - $MODULE_DIR/$MODULE_NAME/__init__.py  has not been created" 
fi


####################
# admin.py
####################

cat <<EOF > $MODULE_DIR/$MODULE_NAME/admin.py  
from django.contrib import admin

# Register your models here.
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$MODULE_NAME/admin.py has been created "
else
    echo "*  ERROR - $MODULE_DIR/$MODULE_NAME/admin.py  has not been created"
fi



####################
# models.py
####################

cat << EOF > $MODULE_DIR/$MODULE_NAME/models.py
from django.db import models

# Create your models here.
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$MODULE_NAME/model.py has been created "
else
    echo "*  ERROR - $MODULE_DIR/$MODULE_NAME/model.py  has not been created"
fi



####################
# views.py
####################

cat << EOF > $MODULE_DIR/$MODULE_NAME/views.py
from django.shortcuts import render

# Create your views here.
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$MODULE_NAME/view.py has been created "
else
    echo "*  ERROR - $MODULE_DIR/$MODULE_NAME/viewl.py  has not been created"
fi


####################
# tests.py
####################

cat <<EOF > $MODULE_DIR/$MODULE_NAME/tests.py
from django.test import TestCase

# Create your tests here.
EOF

if [ $? = 0 ] ; then
    echo "-> $MODULE_DIR/$MODULE_NAME/tests.py has been created "
else
    echo "*  ERROR - $MODULE_DIR/$MODULE_NAME/test.py  has not been created"
fi



}

#
setupDir
setupFile
createAppFile 
