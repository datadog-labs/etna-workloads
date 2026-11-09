#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2015 --module commonjs input.ts --outDir out
cat out/input.d.ts
