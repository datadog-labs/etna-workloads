#!/bin/bash
node "$TSC" --target es2015 --removeComments false --outFile out.js input.ts
cat out.js
