#!/bin/bash --
if [ $# -gt 0 ] ; then
  dirname="$1"
else
  dirname=$(pwd)
fi
echo "$dirname" | sed -e s@$HOME@~@ | sed -e 's@\(/.\)[^/]\+/@\1/@g'
