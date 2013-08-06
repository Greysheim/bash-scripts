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
mountPoint="/Volumes/$volName"

# If already mounted, abort
if [ ! -z "$(mount | grep "$mountPoint")" ]; then
   echo "mountrimu: cannot mount: $mountPoint already mounted" >&2
   exit 1
fi

# If mountpoint doesn't exist, create it;
# Else if it exists and is not empty, abort
if [ ! -d "$mountPoint" ]; then
   echo "mountrimu: creating $mountPoint"
   mkdir $mountPoint
elif [ ! -z "$(ls -A "$mountPoint")" ]; then
   echo "mountrimu: cannot mount: $mountPoint not empty" >&2
   exit 1
fi

# Attempt to mount
#echo "mountrimu: mounting..."
sshfs "$hostName" "$mountPoint" -o reconnect,volname="$volName"
exit $?
