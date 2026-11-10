#!/bin/bash
node "$TSC" --jsx react-jsxdev --target es2020 --module esnext --noCheck --outDir out input.tsx 2>&1
cat out/input.js
