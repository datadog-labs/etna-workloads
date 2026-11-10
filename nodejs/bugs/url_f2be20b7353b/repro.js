const u = new URL('https://user:pw@example.com:8080/a/b?q=1#h');
try { u.href = 'not a url'; } catch (e) { console.log(e.code); }
console.log(u.href);
console.log(u.host, u.pathname, u.search, u.hash);
