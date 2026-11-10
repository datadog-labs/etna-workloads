const util = require('util');
class Foo { constructor(){ this.a = 1; } get b(){ return this.a + 1; } }
class Bar extends Foo { get c(){ return this.a + 10; } }
let o = new Bar();
try { console.log(util.inspect(o, {getters:true, showHidden:true})); } catch(e){ console.log('ERR', e.message); }
