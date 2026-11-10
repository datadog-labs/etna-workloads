#!/bin/bash
node "$TSC" --target es2015 --module commonjs input.ts 2>&1 | grep -E '^input.ts|Debug Failure'
echo "exit: ${PIPESTATUS[0]}"
grep -A12 'let C = ' input.js 2>/dev/null
