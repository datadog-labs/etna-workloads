#!/bin/bash
node "$TSC" --incremental --tsBuildInfoFile out.tsbuildinfo --module esnext --moduleResolution bundler --target es2020 --noEmit data.d.json.ts input.ts | sed 's/ was resolved to.*but/ was resolved but/'
grep -o '"referencedMap":[^]]*]]' out.tsbuildinfo || echo "no referencedMap"
