#!/bin/bash
node "$TSC" --target es2015 --declaration --noEmit false --outDir out input.ts
echo "exit $?"
cat out/input.d.ts
