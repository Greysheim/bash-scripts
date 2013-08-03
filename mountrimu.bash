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

hostName="grey@rimu:/"
volName="GreyRimu"
mountPoint="/Volumes/$volName/"

# Create mount point and mount; capture output in $result
# If mount fails, remove mount point if it exists and is empty
result=$( mkdir $mountPoint 2>&1 ) && \
result="$result"$( sshfs $hostName $mountPoint -o reconnect,volname="$volName" 2>&1 ) && \
result="$result""Successful mount!" || \
rmdir $mountPoint &> /dev/null

# Display output in alert window (Mac OS X)
# /usr/bin/osascript -e "tell app \"System Events\" to display alert \"$result\"" &> /dev/null

# Display output in stdout
echo -e "$result"
