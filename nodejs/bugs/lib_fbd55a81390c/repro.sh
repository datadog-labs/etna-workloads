#!/bin/bash
# Worker creation must not crash when SharedArrayBuffer is disabled.
cd "$(mktemp -d)"
cat > t.js <<'JS'
const { Worker } = require('worker_threads');
if (!process.env.HAS_STARTED_WORKER) {
  process.env.HAS_STARTED_WORKER = 1;
  const w = new Worker(__filename);
  w.on('exit', (s) => console.log('worker exit', s));
} else process.exit(2);
JS
"$1" --enable-sharedarraybuffer-per-context t.js 2>&1 | head -5
echo "exit=${PIPESTATUS[0]}"
