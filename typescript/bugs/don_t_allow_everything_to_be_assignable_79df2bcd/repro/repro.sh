#!/bin/bash
node "$TSC" --strict --target es2015 --noEmit --pretty false input.ts
echo "exit $?"
