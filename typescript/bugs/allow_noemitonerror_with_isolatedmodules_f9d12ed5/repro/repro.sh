#!/bin/bash
node "$TSC" --noEmitOnError --isolatedModules --target es2020 --outDir out input.ts; echo "exit=$?"
cat out/input.js
