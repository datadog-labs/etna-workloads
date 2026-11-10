#!/bin/bash
node "$TSC" --target es2022 --lib esnext --outFile out.js input.ts
node out.js 2>&1 | head -3
echo "exit: ${PIPESTATUS[0]}"
