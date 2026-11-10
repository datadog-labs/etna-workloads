#!/bin/bash
node "$TSC" -b tests >/dev/null 2>&1
echo built
node watch.cjs
