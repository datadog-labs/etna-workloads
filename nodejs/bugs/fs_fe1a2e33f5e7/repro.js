const fs=require('fs'),os=require('os'),path=require('path');
const d=fs.mkdtempSync(path.join(os.tmpdir(),'r-'));
const a=path.join(d,'a'),b=path.join(d,'b'),c=path.join(d,'c');
fs.writeFileSync(a,'file a');fs.mkdirSync(b);fs.symlinkSync(b,c,'dir');
try{fs.cpSync(a,c,{dereference:false});
console.log('ok',fs.lstatSync(c).isFile(),fs.readFileSync(c,'utf8'));}
catch(e){console.log('error',e.code);}
fs.rmSync(d,{recursive:true});
