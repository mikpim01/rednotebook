#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"
cd ../

set +eo pipefail
python3 -m pyflakes rednotebook tests | grep -v "undefined name '_'" | grep -v "rednotebook/external/"
retval=$?
set -eo pipefail
if [[ $retval == 0 ]]; then
    echo "pyflakes found errors."
    exit 1
fi

# Check for PEP8 errors:
# E402: module level import not at top of file
# W504: line break after binary operator
PEP8_OPTS="--max-line-length=110"
python3 -m pycodestyle $PEP8_OPTS --exclude=external,journal.py rednotebook tests
python3 -m pycodestyle $PEP8_OPTS --ignore=E402,W504 rednotebook/journal.py

./dev/find-dead-code.sh

python3 setup.py build_trans

echo "All tests passed"
