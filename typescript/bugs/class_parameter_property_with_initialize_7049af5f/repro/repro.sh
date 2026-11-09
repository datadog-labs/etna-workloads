#!/bin/bash
node "$TSC" --target es2015 --declaration --strict --emitDeclarationOnly --declarationDir out input.ts
cat out/input.d.ts
