#!/bin/bash
node "$TSC" -p tsconfig.json 2>&1 | grep -v '^\s*at ' | head -20
echo "exit: ${PIPESTATUS[0]}"
