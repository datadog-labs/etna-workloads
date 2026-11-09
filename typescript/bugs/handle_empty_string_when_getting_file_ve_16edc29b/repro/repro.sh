#!/bin/bash
rm -rf out
node "$TSC" -b tsconfig.json
touch -d '+1 hour' a.ts
node "$TSC" -b -v tsconfig.json | sed -E 's/^[0-9:]+ [AP]M - //' | grep -E "Project 'tsconfig.json'"
