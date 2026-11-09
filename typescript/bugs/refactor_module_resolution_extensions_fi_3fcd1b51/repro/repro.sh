#!/bin/bash
node "$TSC" --noEmit --moduleResolution node10 --ignoreDeprecations 6.0 --module commonjs --allowJs --traceResolution input.ts | sed "s#$PWD##g" | grep "target file types"
