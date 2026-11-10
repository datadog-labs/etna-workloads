#!/bin/bash
# Bare `node --run` should list scripts (exit 9) instead of erroring on missing argument.
d=$(mktemp -d)
cd "$d"
echo '{"scripts":{"hello":"echo hi"}}' > package.json
timeout 10 "$1" --run 2>&1 </dev/null
echo "exit=$?"
