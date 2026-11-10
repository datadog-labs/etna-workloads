#!/bin/sh
# Usage: see etna.py --help.  Thin wrapper: bin/check-repro.sh <checkout-dir> [bug-id]
exec python3 "$(dirname "$0")/etna.py" check-repro "$@"
