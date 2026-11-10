#!/bin/bash
node "$TSC" -p tsconfig.json
echo "exit $?"
cat out/index.d.ts
