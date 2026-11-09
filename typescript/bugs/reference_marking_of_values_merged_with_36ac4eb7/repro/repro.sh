#!/bin/bash
node "$TSC" --module commonjs --target es2015 --outDir out a.ts b.ts c.ts
cat out/c.js
