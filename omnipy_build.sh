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
    brew install $3
    brew link $3
    bottle $1
    rename
    brew unlink $1
    brew unlink $2  
    brew unlink $3
}

brew install openssl@1.1
brew link openssl@1.1
brew unlink omniorb-ssl-py38
brew unlink omniorb-ssl-py39
brew unlink omniorb-ssl-py310
brew unlink omniorb-ssl-py311

build omniorbpy-py38 python@3.8 omniorb-ssl-py38
build omniorbpy-py39 python@3.9 omniorb-ssl-py39
build omniorbpy-py310 python@3.10 omniorb-ssl-py310
build omniorbpy-py311 python@3.11 omniorb-ssl-py311
