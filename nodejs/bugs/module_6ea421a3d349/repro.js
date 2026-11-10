const fs = require('fs'), os = require('os'), path = require('path');
const { registerHooks, createRequire } = require('module');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const pkg = path.join(dir, 'node_modules', 'foo');
fs.mkdirSync(pkg, { recursive: true });
fs.writeFileSync(path.join(pkg, 'package.json'), JSON.stringify({
  name: 'foo', exports: { foo: './foo.js', default: './default.js' },
}));
fs.writeFileSync(path.join(pkg, 'foo.js'), "module.exports = 'foo';");
fs.writeFileSync(path.join(pkg, 'default.js'), "module.exports = 'default';");
const req = createRequire(path.join(dir, 'main.js'));
registerHooks({
  resolve(specifier, context, next) {
    console.log('isArray', Array.isArray(context.conditions));
    context.conditions = ['foo', ...context.conditions];
    return next(specifier, context);
  },
});
try { console.log(req('foo')); } catch (e) { console.log('error', e.code); }
fs.rmSync(dir, { recursive: true, force: true });
