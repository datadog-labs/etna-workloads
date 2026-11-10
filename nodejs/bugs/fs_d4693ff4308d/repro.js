const fs = require('fs');
for (const p of [123, {}, true, [], null]) {
  for (const [name, fn] of [['read', fs.createReadStream], ['write', fs.createWriteStream]]) {
    try {
      const s = fn(p, p === null ? { fd: undefined } : undefined);
      s.on('error', () => {});
      s.destroy();
      console.log(name, typeof p, 'no throw');
    } catch (e) {
      console.log(name, typeof p, e.code);
    }
  }
}
