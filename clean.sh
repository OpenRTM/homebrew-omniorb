#!/bin/bash

build=(
    "omniorb-ssl-py310  python@3.10"
    "omniorb-ssl-py311  python@3.11"
    "omniorb-ssl-py312  python@3.12"
    "omniorb-ssl-py313  python@3.13"
    "omniorb-ssl-py314  python@3.14"
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