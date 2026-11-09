#!/bin/bash
out=$(node "$TSC" --noEmit --target es2015 --esModuleInterop bar.d.ts foo.d.ts 2>&1)
code=$?
echo "$out" | grep -E '^(bar|foo)\.d\.ts|TypeError'
echo "exit: $code"
