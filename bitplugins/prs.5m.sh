#!/bin/bash

# Pull requests list
# BitBar plugin
#
# by Dkunin
#
# Displays list of my PRs and their statuses

curl http://localhost:1919/prs-cli -s
