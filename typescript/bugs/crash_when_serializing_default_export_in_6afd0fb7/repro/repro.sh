#!/bin/bash
node "$TSC" -p tsconfig.json 2>&1 | head -30
echo "exit: ${PIPESTATUS[0]}"
