const b = Buffer.alloc(4);
for (const m of ['utf8Write', 'latin1Write', 'asciiWrite']) {
  try { console.log(m, b[m]('ab', 2n ** 70n)); }
  catch (e) { console.log(m, e.code || e.name, e.message); }
}
