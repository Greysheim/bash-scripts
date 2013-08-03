#!/bin/bash

# compilec - Compiles and executes a program written in C, then deletes the output file again.
# Displays any error messages in less/more for debugging compile errors.
# Uses the GNU Compiler Collection (GCC).
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

echo

# Check if programs this script depends on exist
if ! (which gcc &> /dev/null); then
	echo "GCC not found. Aborting." >&2
	echo
	exit 1
fi
if ! (which less &> /dev/null); then
	echo -n "less not found. Checking for more . . . " >&2
	if ! (which more &> /dev/null); then
		echo "Not found. Aborting." >&2
		echo
		exit 1
	else
		echo "Found. Reverting to more." >&2
		text="more"
	fi
else
	text="less"
fi

# cd to the relevant directory where the *.c files are
param1Check=$(echo $1 | wc -w | awk '{print $1}')

if [ $param1Check != 0 ]; then # Check if the path was passed as a parameter
	thisdir=$1
	cd "$thisdir"
	if [ $? != 0 ]; then
		echo "Error cd'ing to directory passed as input."
		echo
		exit 1
	fi
else
	thisdir=$(dirname "$0")
	cd "$thisdir"
	if [ $? != 0 ]; then
		echo "Error cd'ing to the directory of this script."
		echo "Please use e.g. \"~/CompileC.bash\" instead of \". ~/CompileC.bash\""
		echo "Else pass relevant directory e.g. \". ~/CompileC.bash $(pwd)\""
		echo
		exit 1
	fi
fi

echo "Current directory: $thisdir"

#Check if there are any files named *.c
if ! [ -a *.c ]; then
	echo "No programs found. Aborting."
	echo
	exit 1
fi
numCFiles=$(ls *.c | wc -w | awk '{print $1}')

# If there is only one *.c file in the directory, run it.
# If there are more, ask user which should be run
if [ $numCFiles == 1 ]; then
	Application=$(ls *.c)
	echo "Running $Application"
else
	echo "Please enter the file name of the application to run:"
	ls *.c
	read Application
fi

echo
# Check if the file to be compiled exists
if ! [ -a $Application ]; then
	echo "Application not found. Aborting."
	echo
	exit 1
fi

# Compile and execute, or display errors in less/more if unsuccessful
echo -n "Compiling . . . "
gcc -ansi $Application -o $Application.out 1> compileOut.txt 2> compileErr.txt
compileExitStatus=$?

if [[  $compileExitStatus == 0 && $(cat compileErr.txt | wc -w | awk '{print $1}') == 0 ]]; then
	if [[ $(cat compileOut.txt | wc -w | awk '{print $1}') != 0 ]]; then
		$text < compileOut.txt # Catch-all in case GCC writes anything to stdout (shouldn't)
	fi
	rm compileErr.txt compileOut.txt
	echo "Successful compile."
	echo "Executing application . . ."
	echo
	./$Application.out 2> runErr.txt # Execute
	runExitStatus=$?
	if [[ $runExitStatus != 0 || $(cat runerr.txt | wc -w | awk '{print $1}') != 0 ]]; then
		echo "Run error: $Application.out returned exit status of $runExitStatus" >> runErr.txt
		# Display anything written to stderr, and the program's exit status if != 0
		$text < runErr.txt
	fi
	echo
	rm $Application.out runErr.txt
else
	rm $Application.out 2> /dev/null
	cat compileOut.txt compileErr.txt | $text
	echo "Compile error." >&2
	rm compileOut.txt compileErr.txt
	echo
	exit 1
fi

exit 0
