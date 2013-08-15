#!/bin/bash

# mcrun - Minecraft server wrapper script
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
#
# This file should be placed in the same directory as minecraft_server.jar
# Alternatively, you can run via a symlink placed in that directory.

if [ $PS1 ]; then
   printf '%s\n' "Please run as a subprocess" >&2
   return 1
fi

if ( pgrep -f "minecraft_server" &> /dev/null ); then
   printf '%s\n' "mcrun: minecraft is already running" >&2
   exit 1
fi

# Navigate to directory of this script (or symlink it was called from)
cd "$(dirname "$0" 2> /dev/null)" || exit 1

# Set tmux window title to "minecraft"
oldWName="$(tmux display-message -p "#W" 2> /dev/null)"
[ "$TMUX" ] && tmux renamew "minecraft" &> /dev/null

/usr/bin/java -Xms50M -Xmx350M -jar minecraft_server.jar nogui
exitStatus=$?

[ "$TMUX" ] && tmux renamew "$oldWName" &> /dev/null

exit $exitStatus
