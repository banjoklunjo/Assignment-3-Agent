#!/bin/bash
#
# This script will run the server disconnected from the terminal. It redirects
# all output to the file "nohup.out", which can be watched with the
# "tail -f nohup.out" command. Once the server has been started, this script
# will start watching the command-line output. At this point, you can safely
# use "Control C" to kill the "tail" command, without killing the server. At
# any time you can return to the server directory and use the
# "tail -f nohup.out" command to watch the server's console output.

if [ ! -f scmserver.jar ]
then
    echo "TAC SCM Server jar file missing. Rebuilding..."
    ant
fi

if [ -f nohup.out ]
then
    rm nohup.out
fi
touch nohup.out

nohup java -server -jar scmserver.jar &

tail -f nohup.out

