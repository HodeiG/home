#!/bin/bash
function error() {
    echo "$1"
    exit 1
}

CRYPT_REPO=$HOME/Dropbox/workspace
LOCAL_EXISTED=false
REMOTE_EXISTED=false

test -n "$1" || error "Full path to the repository. If it doesn't exist will \
be created"
test -n "$2" || error "GPG key not provided. See 'gpg --list-keys'"

REPO_DIR=$(dirname "$1")
REPO_NAME=$(basename "$1")
GPG_KEY="$2"

# set -x
# set -v
# set -e
# 1. Create remote encrypted repo
#==================================
if [ ! -d "$CRYPT_REPO/$REPO_NAME" ] ; then
    mkdir -p "$CRYPT_REPO/$REPO_NAME/src"
    mkdir -p "$CRYPT_REPO/$REPO_NAME/docs"
    cd "$CRYPT_REPO/$REPO_NAME/src" || error "Cannot cd to encrypted src directory."
    git init .
    git config --bool core.bare true
else
    echo "Remote encrypted repo already exists."
    REMOTE_EXISTED=true
fi

# 2. Create local source repo
#===============================
mkdir -p "$REPO_DIR/$REPO_NAME"
cd "$REPO_DIR/$REPO_NAME" || error "Cannot cd to src directory."

# If not git repo initialize it
if ! git rev-parse --git-dir &> /dev/null ; then
    git init .
else
    echo "Local repo already exists."
    LOCAL_EXISTED=true
fi

# If remote gcrypt doesn't exist add it
if ! git remote show | grep -q crypt ; then
    git remote add crypt gcrypt::"$CRYPT_REPO/$REPO_NAME/src/"
    git config --add gcrypt.gpg-args "--use-agent"
    git config --add gcrypt.publish-participants true
    git config user.signingkey "$GPG_KEY"
    git config --add gcrypt.participants "$GPG_KEY"
fi

# 3. Update local repo
#===============================
if $REMOTE_EXISTED ; then
    git pull crypt master
elif ! $LOCAL_EXISTED ; then
    touch README
    git add README
    git commit -a -m "First commit."
    git push crypt master
    git remote update # Otherwise git branch -r doesn't show remote branches
fi
