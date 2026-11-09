#!/bin/bash
node "$TSC" -p tsconfig.json
echo "exit: $?"
if grep -q 'default as mod' out/index.d.mts; then echo "OK: default re-export preserved"; else echo "BUG: default re-export rewritten"; fi
