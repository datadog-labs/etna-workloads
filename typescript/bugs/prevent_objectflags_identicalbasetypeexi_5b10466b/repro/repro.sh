#!/bin/bash
node "$TSC" -p tsconfig.json 2>&1 | grep -E "error TS|TypeError" | sed 's/^ *//'
echo "exit: ${PIPESTATUS[0]}"
