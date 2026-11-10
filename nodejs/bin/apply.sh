#!/bin/sh
# Usage: see etna.py --help.  Thin wrapper: bin/apply.sh <checkout-dir> [bug-id]
exec python3 "$(dirname "$0")/etna.py" apply "$@"
