#!/usr/bin/env bash
git pull
grunt includes coffee sass

# uses bash '||' to attempt to restart or start a new server fresh.
forever restart -c coffee server/app.coffee || forever start -c coffee server/app.coffee
service apache2 restart
