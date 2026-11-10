for (const v of [1, 1023, 65536, -1, 0, 1024, 65535]) {
  try { process.debugPort = v; console.log(v, 'ok', process.debugPort); }
  catch (e) { console.log(v, e.code, e.message); }
}
