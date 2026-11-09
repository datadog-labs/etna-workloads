#!/bin/bash
node "$TSC" -p tsconfig.json --listFilesOnly | sed 's#.*/\(a.ts\|b.js\)$#\1#' | grep -E '^(a.ts|b.js)$'
node "$TSC" -p tsconfig.json; echo "exit $?"
