#!/bin/bash
node "$TSC" --strict --target es2015 --declaration --emitDeclarationOnly --outFile out.d.ts input.ts
cat out.d.ts
