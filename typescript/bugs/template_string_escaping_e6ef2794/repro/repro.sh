#!/bin/bash
node "$TSC" input.ts --declaration --emitDeclarationOnly --outDir out 2>&1
cat out/input.d.ts
