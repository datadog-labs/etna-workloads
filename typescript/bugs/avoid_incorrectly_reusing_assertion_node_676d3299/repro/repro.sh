#!/bin/bash
node "$TSC" --strict --target es2015 --declaration --emitDeclarationOnly --outDir out input.ts
cat out/input.d.ts
