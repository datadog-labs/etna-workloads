#!/bin/bash
node "$TSC" foo.js --allowJs --declaration --emitDeclarationOnly --target es2015 --outDir out
cat out/foo.d.ts
