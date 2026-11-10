#!/bin/bash
node "$TSC" a.js --allowJs --declaration --emitDeclarationOnly --target es2015 --outDir out
cat out/a.d.ts
