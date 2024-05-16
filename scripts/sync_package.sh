#!/bin/bash

# The purpose of this script is to:
# 1. Pull the latest code from the remote repository for a given git directory
# 2. Uses `rsync` to copy the new code to a remote server but excludes the `.git` directory and any other directories specified by the user

# Usage:
# ./sync_package.sh <git_directory> <remote_server> <remote_directory> "(<exclude_directories>)"

if [ $# -lt 3 ]; then
    echo "Illegal number of parameters"
    echo "Usage: ./sync_package.sh <git_directory> <remote_server> <remote_directory> '(<exclude_directories>)'"
    exit 1
fi

GIT_DIR=$1
REMOTE_SERVER=$2
REMOTE_DIR=$3

cd $GIT_DIR
git pull
cd -

EXCLUDE_OPTS="--exclude=.git"
if [ $# -gt 3 ]; then
    EXCLUDE_DIRS=$(echo $4 | tr -d '()')
    IFS=' ' read -r -a EXCLUDE_ARRAY <<< "$EXCLUDE_DIRS"

    for dir in "${EXCLUDE_ARRAY[@]}"; do
        EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude=$dir"
    done
fi

rsync -avz $EXCLUDE_OPTS $GIT_DIR $REMOTE_SERVER:$REMOTE_DIR/

echo "Code has been successfully synced to the remote server"
