#!/bin/bash

# mountrimu - Mounts network volume using sshfs
# Copyright Daniel Cranston 2013.
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

logFile="/Users/dax/.dax/mountrimu.log"
volName="GreyRimu"
mountPoint="/Volumes/$volName/"


mkdir $mountPoint > $logFile 2>&1 && \
/usr/local/bin/sshfs grey@rimu:/ $mountPoint -o reconnect,volname="$volName" >> $logFile 2>&1 && \
echo "Successful mount!" >> $logFile

# Uncomment one of these lines for verbosity.
# /usr/bin/osascript -e "tell app \"System Events\" to display alert \"$(cat $logFile)\"" &> /dev/null # Display output in alert window
cat $logFile # Display output in stdout

rm $logFile
