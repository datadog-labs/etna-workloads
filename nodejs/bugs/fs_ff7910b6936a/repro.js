const { spawn, execFileSync } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'repro-'));
const fifo = path.join(dir, 'fifo');
execFileSync('mkfifo', [fifo]);
// Writer sends data in pieces with pauses, so reads on the FIFO are short.
spawn('sh', ['-c',
  'exec 3>"$1"; printf "first;" >&3; sleep 0.4; printf "second;" >&3; sleep 0.4; printf "third" >&3',
  'sh', fifo], { stdio: 'ignore' });
(async () => {
  console.log(JSON.stringify(await fs.promises.readFile(fifo, 'utf8')));
  fs.rmSync(dir, { recursive: true });
})();
