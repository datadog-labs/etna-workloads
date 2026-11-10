'use strict';
const { Worker } = require('worker_threads');
const w = new Worker(
  `const { Worker } = require('worker_threads');
  new Worker("throw new Error('uncaught')", { eval:true })`,
  { eval: true });
w.on('error', (e) => {
  console.log('error:', e && e.name, e && e.message);
});
w.on('exit', (c) => console.log('exit', c));
