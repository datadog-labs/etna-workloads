const vm = require('vm');
try {
  const f = vm.compileFunction('return 1', [], { lineOffset: -1, columnOffset: -1 });
  console.log('ok', f());
} catch (e) {
  console.log('error', e.code);
}
