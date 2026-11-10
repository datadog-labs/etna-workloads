#!/bin/bash
node "$TSC" --strict --declaration --emitDeclarationOnly --module commonjs --target es2015 --outDir out a.ts
cat out/a.d.ts
