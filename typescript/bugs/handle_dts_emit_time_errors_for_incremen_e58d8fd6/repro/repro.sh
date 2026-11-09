#!/bin/bash
node "$TSC" -p .; echo "exit $?"
echo "--- second run, main.ts changed"
echo 'export const z = 1;' >> main.ts
node "$TSC" -p .; echo "exit $?"
