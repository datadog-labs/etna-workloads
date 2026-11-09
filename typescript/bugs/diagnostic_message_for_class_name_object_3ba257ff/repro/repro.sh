#!/bin/bash
node "$TSC" --noEmit --module commonjs --target es2015 input.ts
true
