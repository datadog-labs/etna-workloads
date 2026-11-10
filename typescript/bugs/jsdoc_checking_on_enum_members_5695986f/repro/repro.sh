#!/bin/bash
node "$TSC" --strict --noUnusedLocals --noEmit --target es2015 input.ts a.ts
echo "exit: $?"
