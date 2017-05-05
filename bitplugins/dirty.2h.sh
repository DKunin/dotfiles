#!/bin/bash

# Get dirty projects (not staged, or non commited)
# BitBar plugin
#
# by Dkunin

MAIN_PROJECTS=$(/Users/dikunin/bin/dirty /Users/dikunin/Projects | wc -l | tr -d '[[:space:]]')
SUB_PROJECTS=$(/Users/dikunin/bin/dirty /Users/dikunin/SubProject | wc -l | tr -d '[[:space:]]')
echo $MAIN_PROJECTS/$SUB_PROJECTS