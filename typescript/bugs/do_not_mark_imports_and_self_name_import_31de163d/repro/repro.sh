#!/bin/bash
node "$TSC" -p tsconfig.json
echo "exit: $?"
find dist -type f | sort
