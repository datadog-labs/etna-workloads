const et = new EventTarget();
let n = 0;
const f = () => n++;
et.addEventListener('x', f, { once: true });
et.dispatchEvent(new Event('x'));
et.addEventListener('x', f);
et.dispatchEvent(new Event('x'));
console.log('calls', n);
