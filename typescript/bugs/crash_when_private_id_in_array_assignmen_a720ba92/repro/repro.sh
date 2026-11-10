#!/bin/bash
export NODE_ENV=development
node "$TSC" --target es2015 --ignoreDeprecations 6.0 --outFile /dev/stdout input.ts 2>&1 | head -8 | cut -c1-120
echo "exit: ${PIPESTATUS[0]}"
