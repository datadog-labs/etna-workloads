const fs=require('fs'),os=require('os'),path=require('path');
const d=fs.mkdtempSync(path.join(os.tmpdir(),'r-'));
fs.mkdirSync(path.join(d,'real/sub'),{recursive:true});
fs.writeFileSync(path.join(d,'real/sub/f.txt'),'x');
fs.symlinkSync(path.join(d,'real'),path.join(d,'link'));
fs.symlinkSync(path.join(d,'real/sub/f.txt'),path.join(d,'flink'));
const show=(l,ents)=>console.log(l,ents.map(e=>e.parentPath.slice(d.length)+'/'+e.name+':'+(e.isSymbolicLink()?'L':e.isDirectory()?'D':e.isFile()?'F':'?')).sort().join(' '));
show('sync',fs.readdirSync(d,{recursive:true,withFileTypes:true}));
fs.readdir(d,{recursive:true,withFileTypes:true},(e,r)=>{
  show('async',r);
  fs.rmSync(d,{recursive:true,force:true});
});
