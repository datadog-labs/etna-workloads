#!/bin/bash
node "$TSC" --module commonjs --target es2015 --experimentalDecorators --emitDecoratorMetadata --outDir out a.ts b.ts
cat out/b.js
