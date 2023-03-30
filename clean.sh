#!/bin/bash

build=(
    "omniorb-ssl-py38   python@3.8"
    "omniorb-ssl-py39   python@3.9"
    "omniorb-ssl-py310  python@3.10"
    "omniorb-ssl-py311  python@3.11"
)

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

install()
{
    for ((i=0; ${#build[*]}>$i; i++)) ; do
        tmp=(${build[$i]})
        echo "Installing: ${tmp[0]}"
        brew install "${tmp[0]}"
        brew unlink  "${tmp[0]}"
    done

}

#-----------
# main
#-----------
cleanup