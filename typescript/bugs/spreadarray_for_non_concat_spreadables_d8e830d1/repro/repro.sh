#!/bin/bash
node "$TSC" --target es5 --lib es2015,dom --ignoreDeprecations 6.0 --outDir out input.ts
node out/input.js
