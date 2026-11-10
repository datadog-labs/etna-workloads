#!/bin/bash
node "$TSC" --declaration --emitDeclarationOnly --target es2015 input.ts
cat input.d.ts
