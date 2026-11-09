declare var arr: any;
var al: any = { length: 2, 0: "a", 1: "b" };
var r = [1, ...al];
console.log(JSON.stringify(r));
