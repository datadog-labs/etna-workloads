#!/bin/bash
node "$TSC" -p tsconfig.json --listFilesOnly | sed 's#.*/##'
