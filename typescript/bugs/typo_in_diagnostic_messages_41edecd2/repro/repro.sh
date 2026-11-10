#!/bin/bash
node "$TSC" --noEmit --traceResolution --moduleResolution node10 --module commonjs input.ts | grep "name resolution result" | sed "s#'[^']*/#'#"
