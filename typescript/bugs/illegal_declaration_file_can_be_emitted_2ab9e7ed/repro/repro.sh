#!/bin/bash
node "$TSC" --target es2015 --declaration --noEmit false --outDir out input.ts
cat out/input.d.ts
