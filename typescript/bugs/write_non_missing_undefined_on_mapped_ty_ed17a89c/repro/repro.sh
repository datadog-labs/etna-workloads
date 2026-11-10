#!/bin/bash
node "$TSC" --strict --exactOptionalPropertyTypes --declaration --emitDeclarationOnly --target es2015 --module commonjs --outDir out input.ts
cat out/input.d.ts
