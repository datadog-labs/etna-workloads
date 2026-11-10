const { Worker } = require('node:worker_threads');
const w = new Worker('console.log("Worker running!")', { eval: true, execArgv: ['--inspect-brk=0'] });
w.on('exit', () => { console.log('exit'); process.exit(0); });
setTimeout(async () => { await w.terminate(); console.log('terminated'); }, 1500);
setTimeout(() => { console.log('timeout: terminate hung'); process.exit(1); }, 6000);
