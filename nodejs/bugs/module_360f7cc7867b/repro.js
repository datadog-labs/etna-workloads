const { spawnSync } = require('child_process');
for (const code of ['if (await 1) {}', 'function f(){}; f(await 1); console.log("ok")']) {
  const r = spawnSync(process.execPath, ['-e', code], { encoding: 'utf8' });
  console.log(JSON.stringify(code), 'status=' + r.status, 'syntaxerror=' + /SyntaxError/.test(r.stderr), 'stdout=' + JSON.stringify(r.stdout));
}
