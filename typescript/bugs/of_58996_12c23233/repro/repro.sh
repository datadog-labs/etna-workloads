#!/bin/bash
node "$TSC" --strict --declaration --emitDeclarationOnly --outDir out input.ts
cat out/input.d.ts
