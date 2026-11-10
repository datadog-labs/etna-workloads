'use strict';
// N-API finalizers must not run synchronously inside GC; they should be
// deferred to a SetImmediate callback.
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const v8 = require('v8');
const vm = require('vm');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'napirepro-'));
fs.writeFileSync(path.join(dir, 'a.cc'), `
#include <stddef.h>
extern "C" {
typedef struct napi_env__* napi_env; typedef struct napi_value__* napi_value;
typedef struct napi_callback_info__* napi_callback_info;
typedef void (*napi_finalize)(napi_env, void*, void*);
typedef napi_value (*napi_callback)(napi_env, napi_callback_info);
int napi_create_object(napi_env, napi_value*);
int napi_add_finalizer(napi_env, napi_value, void*, napi_finalize, void*, void*);
int napi_create_function(napi_env, const char*, size_t, napi_callback, void*, napi_value*);
int napi_create_int32(napi_env, int, napi_value*);
int napi_set_named_property(napi_env, napi_value, const char*, napi_value);
static int count = 0;
static void fin(napi_env, void*, void*) { count++; }
static napi_value make(napi_env env, napi_callback_info) {
  napi_value o; napi_create_object(env, &o);
  napi_add_finalizer(env, o, NULL, fin, NULL, NULL); return o;
}
static napi_value get(napi_env env, napi_callback_info) {
  napi_value r; napi_create_int32(env, count, &r); return r;
}
napi_value napi_register_module_v1(napi_env env, napi_value exports) {
  napi_value f;
  napi_create_function(env, "make", 4, make, NULL, &f);
  napi_set_named_property(env, exports, "make", f);
  napi_create_function(env, "get", 3, get, NULL, &f);
  napi_set_named_property(env, exports, "get", f);
  return exports;
}
}
`);
const r = spawnSync('g++', ['-shared', '-fPIC', '-o', path.join(dir, 'a.node'),
                            path.join(dir, 'a.cc')], { encoding: 'utf8' });
if (r.status !== 0) { console.log('compile failed'); process.exit(2); }

const addon = require(path.join(dir, 'a.node'));
v8.setFlagsFromString('--expose-gc');
const gc = vm.runInNewContext('gc');
(function() { for (let i = 0; i < 10; i++) addon.make(); })();
gc(); gc();
console.log('finalizers run synchronously during gc():', addon.get() > 0);
setImmediate(() => {
  console.log('finalizers run after immediate:', addon.get() > 0);
  fs.rmSync(dir, { recursive: true, force: true });
});
