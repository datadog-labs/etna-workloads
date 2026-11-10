if (!process.execArgv.includes('--experimental-stream-iter')) {
  const r = require('child_process').spawnSync(process.execPath, ['--experimental-stream-iter', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const { Broadcast } = require('stream/iter');
async function main() {
  let returned = false;
  const source = {
    [Symbol.asyncIterator]() {
      return {
        next() { return new Promise(() => {}); },
        return() { returned = true; return Promise.resolve({ done: true }); },
      };
    },
  };
  const { broadcast: bc } = Broadcast.from(source);
  bc.push();
  await new Promise((r) => setTimeout(r, 50));
  bc.cancel();
  await new Promise((r) => setTimeout(r, 100));
  console.log('source return called:', returned);
}
main();
