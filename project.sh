#!/usr/bin/env bash

#####
# change this part for your own configuration
#####

PROJECT_DIR="wordpress"
CONFIG_DIR="${PWD##*/}"
WORDPRESS_TAG="4.4.1"

####
. ./project.env.sh
####


####
# implement you own cli wrapper
####

xcompose () {
    cd "$CONFIG_PATH" && docker-compose $@
}
xgit () {
    git "$@"
}

if [ "$INBOX" != true ]; then
  if callInbox "which docker-compose >> /dev/null"; then
      xcompose () {
          callInbox "docker-compose $@"
      }
  fi
fi