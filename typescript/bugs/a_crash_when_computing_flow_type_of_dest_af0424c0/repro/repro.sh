#!/bin/bash
node "$TSC" --target es2015 --strict --noEmit input.ts 2>&1 | head -8
echo "exit: ${PIPESTATUS[0]}"
