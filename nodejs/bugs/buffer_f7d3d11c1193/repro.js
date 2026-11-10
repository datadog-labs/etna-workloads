const b = Buffer.from('abcdef', 'utf16le');
const n = 'b';
console.log(b.indexOf(n, 1, 'utf16le'));
console.log(b.indexOf(n, 3, 'utf16le'));
console.log(b.includes(n, 1, 'utf16le'));
console.log(Buffer.from('aXbX','utf16le').indexOf('X', 1, 'utf16le'));
