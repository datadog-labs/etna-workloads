const vm = require('vm');
process.removeAllListeners('warning');
process.on('warning', () => {});
const t = setTimeout(() => { console.log('promise never resolved'); process.exit(1); }, 5000);
vm.measureMemory({ mode: 'summary', execution: 'eager' }).then((r) => {
  clearTimeout(t);
  console.log('resolved', typeof r.total.jsMemoryEstimate);
});
