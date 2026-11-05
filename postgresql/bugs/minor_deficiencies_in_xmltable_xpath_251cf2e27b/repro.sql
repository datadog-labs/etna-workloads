SELECT * FROM XMLTABLE('.' PASSING XMLELEMENT(NAME a) columns a varchar(20) PATH '"<foo/>"', b xml PATH '"<foo/>"');
SELECT * FROM XMLTABLE('*' PASSING '<e>pre<!--c1--><?pi arg?><n2>&amp;deep</n2>post</e>' COLUMNS y xml PATH '/');
