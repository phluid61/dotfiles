#!/bin/bash --

BRANCH=$(git branch 2>/dev/null)
if [ $? != 0 ] ; then
    exit
fi

echo "$BRANCH" | grep '^*' | sed -e 's/* / @/' | tr -d '\n'
