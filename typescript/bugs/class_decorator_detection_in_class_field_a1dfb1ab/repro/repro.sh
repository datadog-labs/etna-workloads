#!/bin/bash
node "$TSC" --target esnext --useDefineForClassFields false --outDir out input.ts >/dev/null 2>&1
echo "exit: $?"
cat out/input.js 2>/dev/null | sed -n '/const Foo/,$p'
