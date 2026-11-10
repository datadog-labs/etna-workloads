#!/bin/bash
node "$TSC" --strict --noEmit --target es2015 --lib es2015,dom input.ts
echo "exit $?"
