#!/bin/bash
node "$TSC" --noEmit --module commonjs --target es2015 main.ts types.ts values.ts
echo "exit: $?"
