const u = new URL('http://example.com:8080/');
console.log(u.origin);
const v = new URL('http://example.com/');
v.hostname = 'other.org';
console.log(v.origin);
class H extends URL { get hostname() { return 'overridden.test'; } get host() { return 'real.test:1'; } }
console.log(new H('http://a.com:81/').origin);
