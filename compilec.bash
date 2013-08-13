#!/bin/bash

# compilec - Compiles and executes C program(s) then deletes output file.
# Displays any error messages in less for debugging compile errors.
# Copyright Daniel Cranston 2008-2013.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# This file is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this file. If not, see <http://www.gnu.org/licenses/>.

if [ $PS1 ]; then
   echo "compilec: Please run as a subprocess" >&2
   return 10
fi

scriptName="$(basename "$0")"

if [ $2 ]; then
   echo "$scriptName: Too many args" >&2
   exit 11
fi

if ( ! which gcc less &> /dev/null ); then
   echo "$scriptName: Dependencies not found" >&2
   exit 20
fi

#echo '$scriptName-debug: $1:' "$1"

# If parameter is a directory, go there; else assume it is a file to run
if [ $1 ]; then
   if [ -d $1 ]; then
      cd $1 || exit 30
   else
      app="$1"
   fi
fi

# If file not yet specified
if [ -z "$app" ]; then
   # Check if there are any files named *.c in directory
   if ( ! ls *.c &> /dev/null ); then
      echo "$scriptName: No programs found" >&2
      exit 40
   fi

   # If directory contains one *.c file, run it; else ask user to specify
   if [ $(ls *.c | wc -w) == 1 ]; then
      app=$(ls *.c)
      #echo "Running $app"
   else
      echo "Please enter the file name of the application to run:"
      ls *.c
      read app
   fi
fi

# Check if the file to be compiled exists
if ! [ -a $app ]; then
   echo "compilec: $app not found" >&2
   exit 50
fi

# Create temp files for EXEcutable, Compile stdOUT and Compile stdERR
exe=$(mktemp)
cOut=$(mktemp)
cErr=$(mktemp)
#echo -n "Compiling... "
gcc -ansi $app -o $exe 1> $cOut 2> $cErr
cExit=$?
# If compile successful, execute and display any run errors;
# Else display output from compile
if [[ $cExit == 0 &&  (! -s $cErr) ]]; then
   [ -s $cOut ] && less $cOut
   rm $cErr $cOut
   #echo "Executing..."
   rErr=$(mktemp)
   $exe 2> $rErr
   rExit=$?
   if [[ $rExit != 0 || -s $rErr ]]; then
      [ -s $rErr ] && less $rErr
      echo "$scriptName: Run error: $app exited $rExit" >&2
   fi
   rm $exe $rErr
else
   #echo
   rm $exe 2> /dev/null
   ( [ -s $cOut ] || [ -s $cErr ] ) && cat $cOut $cErr | less
   echo "$scriptName: Compile error: gcc exited $cExit" >&2
   rm $cOut $cErr
   exit 60
fi

exit 0
