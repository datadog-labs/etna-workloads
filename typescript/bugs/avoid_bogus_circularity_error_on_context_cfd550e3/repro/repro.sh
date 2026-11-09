#!/bin/bash
node "$TSC" --noEmit --noImplicitAny --target es2015 --lib esnext input.ts
echo "exit $?"
