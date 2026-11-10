#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --outDir out input.ts
cat out/input.d.ts
