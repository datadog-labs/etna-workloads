#!/bin/bash
node "$TSC" --module commonjs --target es2015 --importHelpers --noEmitHelpers --esModuleInterop --outDir out main.ts other.ts tslib.d.ts
cat out/main.js
