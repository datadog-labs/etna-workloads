#!/bin/bash
node "$TSC" --target es2015 --strict --noEmit --pretty false input.ts
echo "exit $?"
