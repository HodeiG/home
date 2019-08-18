#!/bin/bash
function error() {
    echo "$1"
    exit 1
}

CRYPT_REPO=$HOME/Dropbox/workspace
SRC_REPO=$HOME/src

test -n "$1" || error "Repository name not given."
test -n "$2" || error "GPG key not provided. See 'gpg --list-keys'"
test ! -d "$CRYPT_REPO/$1" || error "Encrypted repository already exists."
test ! -d "$SRC_REPO/$1" || error "Source repository already exists."

REPO_NAME="$1"
GPG_KEY="$2"

# set -x
# set -v
# set -e
# 1. Create backend encrypted repo
#==================================
mkdir -p "$CRYPT_REPO/$REPO_NAME/src"
mkdir -p "$CRYPT_REPO/$REPO_NAME/docs"
cd "$CRYPT_REPO/$REPO_NAME/src" || error "Cannot cd to encrypted src directory."
git init .
git config --bool core.bare true

# 2. Create fronted source repo
#===============================
mkdir -p "$SRC_REPO/$REPO_NAME"
cd "$SRC_REPO/$REPO_NAME" || error "Cannot cd to src directory."
git init .

git remote add crypt gcrypt::"$CRYPT_REPO/$REPO_NAME/src/"
git config --add gcrypt.gpg-args "--use-agent"
git config --add gcrypt.publish-participants true
git config user.signingkey "$GPG_KEY"
git config --add gcrypt.participants "$GPG_KEY"

# 3. First commit
#===============================
touch README
git add README
git commit -a -m "First commit."
git push crypt master
git remote update # Otherwise git branch -r doesn't show remote branches
