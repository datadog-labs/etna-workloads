#!/bin/bash
node "$TSC" --target es2020 --module commonjs --strict --experimentalDecorators --emitDecoratorMetadata --outDir out input.ts
cat out/input.js
