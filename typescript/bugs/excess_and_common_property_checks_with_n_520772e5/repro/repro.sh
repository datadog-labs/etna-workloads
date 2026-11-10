#!/bin/bash
node "$TSC" --strict --noEmit --target es2015 --pretty false input.ts
echo "exit: $?"
