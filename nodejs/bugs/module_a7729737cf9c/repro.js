process.default = 1;
import('node:process').then((m) => {
  console.log(m.default.default);
}, (e) => console.log('error', e && e.name));
