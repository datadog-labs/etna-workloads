#!/bin/bash
node "$TSC" --noEmit --noImplicitAny --target es2015 input.ts
echo "exit $?"
