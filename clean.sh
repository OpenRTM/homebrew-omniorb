#!/bin/bash

brew_cellar=$(brew --cellar)

formulas="
    omniorbpy-py38
    omniorbpy-py39
    omniorbpy-py310
    omniorbpy-py311
    omniorb-ssl-py38
    omniorb-ssl-py39
    omniorb-ssl-py310
    omniorb-ssl-py311
    "

brew_unlink()
{
    for f in $formulas; do
        if test -d $brew_cellar/$f ; then
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
        if test -d $brew_cellar/$f ; then
            echo brew uninstall --ignore-dependencies $f
            brew uninstall --ignore-dependencies $f
        else
            echo Keg $f not found, skipped
        fi
        brew cleanup -s $f
    done
}

if test "x$1" = "xuninstall" ; then
    brew_uninstall
else
    brew_unlink
fi

