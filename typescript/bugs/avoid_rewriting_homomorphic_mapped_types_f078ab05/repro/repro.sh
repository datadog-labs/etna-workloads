#!/bin/bash
node "$TSC" --target es2015 --declaration --emitDeclarationOnly --keyofStringsOnly --ignoreDeprecations 6.0 input.ts
cat input.d.ts
