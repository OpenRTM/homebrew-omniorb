#!/bin/bash

brew_cellar=$(brew --cellar)
echo $brew_cellar

formulas="
    omniorb-ssl-py38
    omniorb-ssl-py39
    omniorb-ssl-py310
    omniorb-ssl-py311
"

brew_install()
{
    for f in $formulas; do
        echo brew install $f
        brew install $f
        brew unlink $f
    done
}

brew_install
