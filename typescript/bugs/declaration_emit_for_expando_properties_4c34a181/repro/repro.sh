#!/bin/bash
node "$TSC" input.ts --declaration --emitDeclarationOnly --strict --target es6 --outDir out
cat out/input.d.ts
