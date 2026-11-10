'use strict';
const fs = require('fs');
const os = require('os');
const path = require('path');
const cp = require('child_process');
const ah = require('async_hooks');

const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'napirepro-'));
const src = path.join(dir, 'b.c');
fs.writeFileSync(src, `
#include <stddef.h>
typedef struct napi_env__* napi_env; typedef struct napi_value__* napi_value;
typedef struct napi_callback_info__* napi_callback_info;
typedef struct napi_async_context__* napi_async_context;
typedef napi_value (*napi_callback)(napi_env, napi_callback_info);
int napi_get_cb_info(napi_env, napi_callback_info, size_t*, napi_value*, napi_value*, void**);
int napi_create_string_utf8(napi_env, const char*, size_t, napi_value*);
int napi_async_init(napi_env, napi_value, napi_value, napi_async_context*);
int napi_async_destroy(napi_env, napi_async_context);
int napi_make_callback(napi_env, napi_async_context, napi_value, napi_value, size_t, const napi_value*, napi_value*);
int napi_create_function(napi_env, const char*, size_t, napi_callback, void*, napi_value*);
napi_value MakeCallback(napi_env env, napi_callback_info info) {
  size_t argc = 3; napi_value a[3];
  napi_get_cb_info(env, info, &argc, a, NULL, NULL);
  napi_value name; napi_create_string_utf8(env, "test", 4, &name);
  napi_async_context ctx; napi_async_init(env, a[0], name, &ctx);
  napi_value r;
  napi_make_callback(env, ctx, a[1], a[2], 0, NULL, &r);
  napi_async_destroy(env, ctx);
  return r;
}
napi_value napi_register_module_v1(napi_env env, napi_value exports) {
  napi_value fn; napi_create_function(env, "makeCallback", 6 + 6, MakeCallback, NULL, &fn);
  return fn;
}
`);
const so = path.join(dir, 'b.node');
cp.execFileSync('gcc', ['-shared', '-fPIC', '-o', so, src]);
const makeCallback = require(so);

const resource = {};
const recv = { isRecv: true };
let initResource;
ah.createHook({
  init(id, type, trigger, res) { if (type === 'test') initResource = res; },
}).enable();
makeCallback(resource, recv, function() {
  console.log('this is recv:', this === recv);
  console.log('executionAsyncResource is resource:',
              ah.executionAsyncResource() === resource);
});
console.log('init resource is resource:', initResource === resource);
fs.rmSync(dir, { recursive: true, force: true });
