#!/bin/bash

#Script to replace "é" with "e" in all files in the current directory

for i in *
do
   mv -v "$i""`echo $i | sed 's/é/e/'`"
done
