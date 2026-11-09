#!/bin/bash
node "$TSC" -p tsconfig.json --pretty false
echo "exit $?"
