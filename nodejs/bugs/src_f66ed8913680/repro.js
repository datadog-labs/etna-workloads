'use strict';
const fs = require('fs'), os = require('os'), path = require('path');
const cp = require('child_process');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'cleanup-repro-'));
const src = path.join(dir, 'a.cc');
fs.writeFileSync(src, `
#include <node_api.h>
#include <stdio.h>
static napi_env g_env;
static void Hook(void* arg) {
  napi_remove_env_cleanup_hook(g_env, Hook, arg);
  puts("hook ran and removed itself");
  fflush(stdout);
}
static int token;
NAPI_MODULE_INIT() {
  g_env = env;
  napi_add_env_cleanup_hook(env, Hook, &token);
  return exports;
}
`);
const inc = path.dirname(process.execPath) + '/addons_headers/include/node';
const so = path.join(dir, 'a.node');
const r = cp.spawnSync('g++', ['-shared', '-fPIC', '-std=c++17', '-I' + inc, '-o', so, src], { encoding: 'utf8' });
if (r.status !== 0) { console.log('compile failed'); console.log(r.stderr); process.exit(2); }
const child = cp.spawnSync(process.execPath, ['-e', `process.dlopen({exports:{}}, ${JSON.stringify(so)}); console.log('loaded')`], { encoding: 'utf8' });
console.log(child.stdout.trim());
console.log('child exit:', child.status, child.signal);
fs.rmSync(dir, { recursive: true, force: true });
