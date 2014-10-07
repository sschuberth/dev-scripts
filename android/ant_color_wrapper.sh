#!/bin/sh

# The general solution is taken from http://stackoverflow.com/a/8129450/1127485.
# Quote the "ant" command to make sure not any alias of the same name is executed, see http://unix.stackexchange.com/a/39296/53328.
"ant" -logger org.apache.tools.ant.listener.AnsiColorLogger "$@" 2>&1 | perl -pe 's/(?<=\e\[)2;//g'
