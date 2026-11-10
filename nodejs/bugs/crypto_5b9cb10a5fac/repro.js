const c = require('crypto');
console.log(typeof c.randomUUIDv7);
try {
  const u = c.randomUUIDv7();
  console.log(/^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/.test(u));
} catch (e) { console.log(e.name); process.exitCode = 1; }
