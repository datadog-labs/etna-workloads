SELECT xmlserialize(DOCUMENT '<foo>   <bar></bar>    </foo>' AS text INDENT);
SELECT xmlserialize(CONTENT  'text node<foo>    <bar></bar>   </foo>' AS text INDENT);
SELECT xmlserialize(DOCUMENT '<foo><bar></bar></foo>' AS text INDENT) ~ E'\n$' AS trailing_nl;
