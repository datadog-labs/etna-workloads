#!/bin/bash
node "$TSC" input.ts --target es2015 --declaration --emitDeclarationOnly --outDir out
cat out/input.d.ts
