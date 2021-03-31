#! /bin/bash
#
# This script is used to run specific commands once entered into a specific
# folder.
#
# Currently, the main purpose will be to load automatically python virtual
# environments within GIT folders, although eventually it might get extended to
# do different things.

VENV=".venv"
GIT_BRANCH=$(git branch 2>/dev/null | awk '/^\*/ {print $2}')


echo "> Executing .env.sh"


if [ -n "$GIT_BRANCH" ] ; then
    # First test if the venv exists with the specific branch name
    if [ -d "${VENV}_${GIT_BRANCH}" ] ; then
        echo "> Loading environment '${VENV}_${GIT_BRANCH}'."
        # shellcheck source=/dev/null
        source "${VENV}_${GIT_BRANCH}/bin/activate"
    elif [ -d "${VENV}" ] ; then
        echo "> Loading environment '${VENV}'."
        # shellcheck source=/dev/null
        source "${VENV}/bin/activate"
    else
        # Nothing to do
        echo "> No python environment to load."
    fi
fi
