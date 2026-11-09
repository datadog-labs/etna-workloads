#!/bin/bash
node "$TSC" input.js --allowJs --declaration --emitDeclarationOnly --strict --outDir out
cat out/input.d.ts
