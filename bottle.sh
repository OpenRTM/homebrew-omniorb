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
bottle $1
rename