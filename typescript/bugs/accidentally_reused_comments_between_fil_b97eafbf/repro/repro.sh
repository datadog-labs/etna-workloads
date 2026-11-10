#!/bin/bash
node "$TSC" --target es2015 --strict --declaration --emitDeclarationOnly --outDir out a.ts
cat out/a.d.ts
