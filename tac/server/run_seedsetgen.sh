#!/bin/bash
#
# This script will run the Seedset Generator GUI program. If the jar file
# is not present, it will be built first.

if [ ! -f scmserver.jar ]
then
    echo "TAC SCM Server jar file missing. Rebuilding..."
    ant
fi

java -cp scmserver.jar edu.umn.cs.tac.seedsetgen.SeedTree
