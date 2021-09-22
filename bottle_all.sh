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
    mv $org_name $new_name
}

brew install openssl@1.1
brew link openssl@1.1

brew install python@3.8
brew link python@3.8
bottle omniorb-ssl-py38
rename
brew unlink omniorb-ssl-py38
brew unlink python@3.8

brew install python@3.9
brew link python@3.9
bottle omniorb-ssl-py39
rename
brew unlink omniorb-ssl-py39
brew unlink python@3.9

brew install python@3.10
brew link python@3.10
bottle omniorb-ssl-py310
brew unlink omniorb-ssl-py310
rename
brew unlink python@3.10

brew install python@3.10
brew link python@3.10
bottle omniorb-ssl
rename
brew unlink omniorb-ssl-py310
brew unlink python@3.10

