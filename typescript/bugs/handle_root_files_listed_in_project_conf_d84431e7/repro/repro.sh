#!/bin/bash
node "$TSC" -b server
node "$TSC" -p server --listFilesOnly | grep -v lib
