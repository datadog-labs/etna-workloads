const { BroadcastChannel, MessageChannel } = require('worker_threads');
const bc = new BroadcastChannel('x');
console.log(Object.prototype.toString.call(bc));
const d = Object.getOwnPropertyDescriptor(Object.getPrototypeOf(bc), Symbol.toStringTag);
console.log(JSON.stringify(d));
const mc = new MessageChannel();
console.log(JSON.stringify(Object.getOwnPropertyDescriptor(MessageChannel.prototype, Symbol.toStringTag)));
bc.close(); mc.port1.close(); mc.port2.close();
