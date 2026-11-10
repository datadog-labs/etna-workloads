try { clearImmediate({}); console.log('ok'); } catch (e) { console.log('threw', e.constructor.name); }
const t = setTimeout(() => {}, 1); 
try { clearImmediate(t); console.log('ok2'); } catch (e) { console.log('threw2', e.constructor.name); }
clearTimeout(t);
setImmediate(() => console.log('immediate ran'));
