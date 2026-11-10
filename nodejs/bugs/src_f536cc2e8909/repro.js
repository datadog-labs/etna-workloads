'use strict';
const fs = require('fs'), os = require('os'), path = require('path');
const cp = require('child_process');
if (process.argv[2] === 'child') {
  require(process.argv[3]).run();
  setInterval(() => {}, 1000);
  return;
}
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const src = path.join(dir, 'a.cc');
fs.writeFileSync(src, `
#include <node_api.h>
#include <pthread.h>
static void* work(void*) { napi_fatal_error("work_thread", NAPI_AUTO_LENGTH, "foobar", NAPI_AUTO_LENGTH); return nullptr; }
static napi_value Run(napi_env env, napi_callback_info) {
  pthread_t t; pthread_create(&t, nullptr, work, nullptr); pthread_detach(t); return nullptr;
}
NAPI_MODULE_INIT() {
  napi_value f; napi_create_function(env, "run", NAPI_AUTO_LENGTH, Run, nullptr, &f);
  napi_set_named_property(env, exports, "run", f); return exports;
}
`);
const inc = path.join(path.dirname(process.execPath), '..', '..', 'src');
const out = path.join(dir, 'a.node');
let r = cp.spawnSync('g++', ['-shared', '-fPIC', '-I' + inc, '-o', out, src, '-lpthread']);
if (r.status !== 0) { console.log('compile failed'); console.log(String(r.stderr)); process.exit(2); }
r = cp.spawnSync(process.execPath, [__filename, 'child', out], { encoding: 'utf8' });
console.log('stderr has message:', r.stderr.includes('FATAL ERROR: work_thread foobar'));
console.log('signal:', r.signal, 'status:', r.status);
fs.rmSync(dir, { recursive: true, force: true });
