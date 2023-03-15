#!/bin/bash

bottle()
{
    brew update
    brew uninstall $1
    brew install --build-bottle $1
    brew bottle $1 | tee bottle.txt
}

rename()
{
    org_name=`grep Bottling bottle.txt| awk '{sub("gz\.\.\.","gz",$3);print $3;}'`
    new_name=`grep Bottling bottle.txt| awk '{sub("--","-",$3);sub("gz\.\.\.","gz",$3);print $3;}'`
    sha_name=`echo $new_name | awk '{sub("tar.gz","sha256");print $1;}'`
    mv $org_name $new_name
    mv bottle.txt $sha_name
}

build()
{
    brew install $2
    brew link $2
    bottle $1
    rename
    brew unlink $1
    brew unlink $2  
}

brew install openssl@1.1
brew link openssl@1.1

build omniorb-ssl-py38 python@3.8
build omniorbpy-py38 python@3.8

build omniorb-ssl-py39 python@3.9
build omniorbpy-py39 python@3.9

build omniorb-ssl-py310 python@3.10
build omniorbpy-py310 python@3.10

build omniorb-ssl-py311 python@3.11
build omniorbpy-py311 python@3.11
