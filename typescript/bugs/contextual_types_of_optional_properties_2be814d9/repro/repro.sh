#!/bin/bash
node "$TSC" --strict --exactOptionalPropertyTypes --noEmit --target es2015 --pretty false input.ts
echo "exit: $?"
