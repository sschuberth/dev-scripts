#!/bin/sh

# Make sure to execute the command, not the alias shadowing it, see:
# http://unix.stackexchange.com/questions/39291/run-a-command-that-is-shadowed-by-an-alias
"ant" -logger org.apache.tools.ant.listener.AnsiColorLogger "$@" | perl -pe 's/(?<=\e\[)2;//g'
