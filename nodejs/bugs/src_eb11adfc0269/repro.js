try { new URLPattern('https://example.com/*', 42); console.log('no throw'); }
catch (e) { console.log(e.name, e.code, e.message); }
