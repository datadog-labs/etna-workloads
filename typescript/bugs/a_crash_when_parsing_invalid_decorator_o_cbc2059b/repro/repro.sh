#!/bin/bash
node "$TSC" --target es2015 --noEmit input.ts 2>&1 | head -20
echo "exit: ${PIPESTATUS[0]}"
