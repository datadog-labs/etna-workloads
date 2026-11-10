'use strict';
const { Worker } = require('worker_threads');
new Worker("require('trace_events')", { eval: true })
  .on('error', (e) => console.log('error', e.code))
  .on('exit', (c) => console.log('exit', c));
