#!/bin/bash

formulas="
    omniorb
    omniorb-ssl-py38
    omniorb-ssl-py39
    omniorb-ssl-py310
    omniorb-ssl
    omniorbpy-py38
    omniorbpy-py39
    omniorbpy-py310
    omniorbpy"

cleanup()
{
    for f in $formulas; do
        if test -d /usr/local/Cellar/$f ; then
            echo brew unlink $f
            brew unlink $f
        else
            echo Keg $f not found, skipped
        fi
    done
}

cleanup
