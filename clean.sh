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

brew_unlink()
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

brew_uninstall()
{
    for f in $formulas; do
        if test -d /usr/local/Cellar/$f ; then
            echo brew uninstall --ignore-dependencies $f
            brew uninstall $f
        else
            echo Keg $f not found, skipped
        fi
    done
}

if test "x$1" = "xuninstall" ; then
    brew_uninstall
else
    brew_unlink
fi

