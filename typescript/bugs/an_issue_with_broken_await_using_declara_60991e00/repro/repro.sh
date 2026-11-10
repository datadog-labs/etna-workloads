#!/bin/bash
node "$TSC" --target es5 --lib esnext --module esnext --strict false --noEmit input.ts
echo "exit=$?"
node "$TSC" --target es2022 --lib esnext --module esnext --outDir out input.ts
echo "exit=$?"
cat out/input.js
