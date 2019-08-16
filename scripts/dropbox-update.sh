#!/bin/bash
function error() {
    echo "$1"
    exit 1
}

DROPBOX_DAEMON_ERR="Dropbox daemon script not installed."

# Kill dropbox
##############
# 1. Check dropbox.py file exists in PATH
# Otherwise download it from:
# https://www.dropbox.com/download?dl=packages/dropbox.py
command -v dropbox.py > /dev/null || error "$DROPBOX_DAEMON_ERR"

# 2. Stop dropbox daemon
dropbox.py stop

# Update dropbox
################
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | \
    tar xzf -

# Start dropbox
################
dropbox.py start
