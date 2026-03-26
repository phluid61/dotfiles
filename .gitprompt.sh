#!/bin/bash --

BRANCH=$(git branch --no-color --show-current 2>/dev/null)
if [ -n "$BRANCH" ] ; then
	echo " @$BRANCH"
fi
