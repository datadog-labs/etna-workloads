const { spawnSync } = require('child_process');
const fs = require('fs'), os = require('os'), path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'napi-null-'));
const src = path.join(dir, 'a.c'), out = path.join(dir, 'a.node');
fs.writeFileSync(src, `
typedef struct napi_env__* napi_env;
typedef struct napi_value__* napi_value;
typedef struct napi_callback_info__* napi_callback_info;
int napi_create_string_utf8(napi_env, const char*, unsigned long, napi_value*);
int napi_create_string_latin1(napi_env, const char*, unsigned long, napi_value*);
int napi_create_string_utf16(napi_env, const void*, unsigned long, napi_value*);
int napi_create_int32(napi_env, int, napi_value*);
int napi_set_named_property(napi_env, napi_value, const char*, napi_value);
napi_value Init(napi_env env, napi_value exports) {
  napi_value r; napi_value v;
  int s;
  s = napi_create_string_latin1(env, 0, 5, &r);
  napi_create_int32(env, s, &v); napi_set_named_property(env, exports, "latin1", v);
  s = napi_create_string_utf16(env, 0, 5, &r);
  napi_create_int32(env, s, &v); napi_set_named_property(env, exports, "utf16", v);
  s = napi_create_string_utf8(env, 0, 5, &r);
  napi_create_int32(env, s, &v); napi_set_named_property(env, exports, "utf8", v);
  return exports;
}
extern napi_value napi_register_module_v1(napi_env, napi_value) __attribute__((alias("Init")));
`);
const cc = spawnSync('gcc', ['-shared', '-fPIC', '-o', out, src], { encoding: 'utf8' });
if (cc.status !== 0) { console.log('compile failed'); process.exit(2); }
const child = spawnSync(process.execPath, ['-e',
  `const m=require(${JSON.stringify(out)});console.log(JSON.stringify(m))`],
  { encoding: 'utf8' });
console.log('stdout:', child.stdout.trim());
console.log('crashed:', child.signal !== null || child.status !== 0);
fs.rmSync(dir, { recursive: true, force: true });
