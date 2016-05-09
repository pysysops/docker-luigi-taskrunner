#!/bin/bash

# Script to run luigi tasks.
# The following assumptions have been made:
#   1. Luigi tasks live in /luigi/tasks VOLUME
#   2. you will maintain a pip requirements with tasks
#   3. Output from Luigi will be in /luigi/outputs VOLUME

source /luigi/.pyenv/bin/activate

cd /luigi/tasks

if [[ -f "requirements.txt" ]]
then
  pip install -r requirements.txt
fi

exec python -m luigi "$@"
