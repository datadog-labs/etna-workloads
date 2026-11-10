const path = require('path');
for (const bad of [123, null, {}, undefined]) {
  try {
    const r = require.resolve('./nonexistent-xyz', { paths: [bad] });
    console.log('resolved', r);
  } catch (e) {
    console.log(e.code || 'no-code');
  }
}
