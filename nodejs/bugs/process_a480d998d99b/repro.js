process.on('warning', () => {});
try {
  process.execve('/bin/echo');
} catch (e) {
  console.log('threw', e.code);
}
