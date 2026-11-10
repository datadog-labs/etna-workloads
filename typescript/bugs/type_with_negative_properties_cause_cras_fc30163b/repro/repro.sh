#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2020 --outFile out.d.ts input.ts 2>&1
cat out.d.ts
