#!/bin/bash
node "$TSC" --strict --declaration --target es2015 --module commonjs --moduleResolution node10 --ignoreDeprecations 6.0 index.ts
cat index.d.ts
