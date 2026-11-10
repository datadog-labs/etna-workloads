'use strict';
process.emitWarning = () => {};
const zlib = require('zlib');
const fs = require('fs');
const os = require('os');
const path = require('path');
const SIG_CENTRAL = 0x02014b50;
const decoy = Buffer.from('SCANNER-SEES-BENIGN!!');
const payload = Buffer.from('UNZIP-SEES-PAYLOAD!!!');
const entry = zlib.ZipEntry.createSync('entry.txt', payload, { method: 'store' });
const chunks = [...zlib.createZipArchiveSync([entry], { baseOffset: decoy.length })];
const buf = Buffer.concat([decoy, ...chunks]);
let c = -1;
for (let i = buf.length - 22; i >= 0; i--) if (buf.readUInt32LE(i) === SIG_CENTRAL) { c = i; break; }
buf.writeUInt32LE(zlib.crc32(decoy), c + 16);
const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'zr-'));
const file = path.join(dir, 'm.zip');
fs.writeFileSync(file, buf);
function t(f) { try { return 'ok:' + f().toString(); } catch (e) { return 'throw:' + e.code; } }
const zip = zlib.ZipFile.openSync(file);
const e = zip.getSync('entry.txt');
for (let i = 0; i < 2; i++) console.log(t(() => e.contentSync()));
zip.closeSync();
fs.rmSync(dir, { recursive: true });
