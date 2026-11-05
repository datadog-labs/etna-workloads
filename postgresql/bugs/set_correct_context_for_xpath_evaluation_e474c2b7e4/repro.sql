SELECT xpath('root', '<root/>');
select * from xmltable('d/r' passing '<d><r><c>2</c></r></d>' columns c text);
