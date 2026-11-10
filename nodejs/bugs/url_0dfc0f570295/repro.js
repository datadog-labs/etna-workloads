const d = Object.getOwnPropertyDescriptor(URL.prototype, 'href');
console.log(d.enumerable, d.get.name, d.set.name);
console.log(Object.keys(URL.prototype).includes('href'));
