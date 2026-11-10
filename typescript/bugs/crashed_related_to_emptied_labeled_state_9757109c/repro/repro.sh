#!/bin/bash
node "$TSC" --target es5 --strict --noEmit false --outFile out.js input.ts 2>&1 | head -5
echo "exit: ${PIPESTATUS[0]}"
cat out.js
