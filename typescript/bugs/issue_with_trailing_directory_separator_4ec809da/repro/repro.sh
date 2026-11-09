#!/bin/bash
rm -rf lib/dist app/node_modules/lib
ln -s ../../lib app/node_modules/lib
node run.mjs
