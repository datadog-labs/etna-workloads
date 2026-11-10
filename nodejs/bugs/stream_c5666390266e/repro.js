const w = new WritableStream({ write() {} });
const writer = w.getWriter();
(async () => {
  await writer.write('a');
  await writer.close();
  try {
    await writer.write('b');
    console.log('no error');
  } catch (e) {
    console.log('rejected:', e.name);
  }
})().catch((e) => console.log('outer:', e.name));
