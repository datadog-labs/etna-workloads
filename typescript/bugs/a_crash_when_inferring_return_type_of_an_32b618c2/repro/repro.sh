#!/bin/bash
node "$TSC" --strict --declaration --emitDeclarationOnly --target es2015 --module commonjs input.ts
cat input.d.ts
