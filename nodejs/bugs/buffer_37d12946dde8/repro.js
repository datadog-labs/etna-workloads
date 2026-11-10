const a = Buffer.from('hello world');
for (const enc of ['utf8', undefined]) {
  try {
    console.log(a.indexOf('\ud800', 0, enc));
    console.log(a.includes('x\udc00y', 0, enc));
    console.log(a.lastIndexOf('\ud83d', undefined, enc));
  } catch (e) { console.log('err', e.message); }
}
