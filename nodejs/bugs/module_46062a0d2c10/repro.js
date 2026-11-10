import('data:application/foo;charset=utf-8,hi').catch(e => {
  console.log(e.code);
  console.log(e.message);
});
