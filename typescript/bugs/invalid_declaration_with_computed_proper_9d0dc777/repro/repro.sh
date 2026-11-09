#!/bin/bash
node "$TSC" --target es2015 --module commonjs --declaration --emitDeclarationOnly --outDir out a.ts b.ts
cat out/b.d.ts
