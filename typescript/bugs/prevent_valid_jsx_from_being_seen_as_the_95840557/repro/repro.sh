#!/bin/bash
node "$TSC" --target es2015 --jsx react --noEmit false --outFile /dev/stdout input.tsx 2>&1
