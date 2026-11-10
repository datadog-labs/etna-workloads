let did = false;
const t = setTimeout(() => {
  console.log('fired');
  if (!did) { did = true; t.refresh(); }
}, 1);
process.on('exit', () => console.log('exit'));
