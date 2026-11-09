#!/bin/bash
node "$TSC" Foo.js --allowJs --checkJs --declaration --emitDeclarationOnly --target es2015 --outDir out
cat out/Foo.d.ts
