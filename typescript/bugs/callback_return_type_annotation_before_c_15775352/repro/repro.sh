#!/bin/bash
node "$TSC" --noEmit --allowJs --checkJs --target es2015 --declaration --emitDeclarationOnly --noEmit false --outDir out input.js
cat out/input.d.ts
