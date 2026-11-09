#!/bin/bash
node "$TSC" --target es2015 --strict --noEmit input.ts > out.txt 2>&1
echo "exit: $?"
grep -E '^input\.ts' out.txt
