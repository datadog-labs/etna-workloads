#!/bin/bash
node "$TSC" --noEmit --erasableSyntaxOnly --target esnext --module esnext input.ts
echo "exit $?"
