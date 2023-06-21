#!/bin/bash

build=(
#    "omniorb-ssl-py39   python@3.9"
#    "omniorb-ssl-py310  python@3.10"
    "omniorb-ssl-py311  python@3.11"
    "omniorb-ssl-py312  python@3.12"
    "omniorb-ssl-py313  python@3.13"
)


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

bottling()
{
    brew install $2
    brew link $2
    bottle $1
    rename
    brew unlink $1
    brew unlink $2  
}

cleanup()
{
    for ((i=0; ${#build[*]}>$i; i++)) ; do
        tmp=(${build[$i]})
        echo "Cleanup: ${tmp[0]}"
        brew unlink "${tmp[0]}"
        brew remove --ignore-dependencies "${tmp[0]}"
        brew cleanup -s "${tmp[0]}"
    done
}

build()
{
    for ((i=0; ${#build[*]}>$i; i++)) ; do
        tmp=(${build[$i]})
        echo "bottling( ${tmp[0]} ${tmp[1]} )"
        bottling ${tmp[0]} ${tmp[1]}
    done
}

#-----------
# main
#-----------
echo "Installing openssl@3"
brew install openssl@3
brew link openssl@3

echo "Bottling the forllowing packages"
cleanup

echo "Bottling openrtm2-aist"
build
