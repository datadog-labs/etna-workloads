CREATE TABLE x (a int);
COPY x to stdout (format TEXT, force_quote(a));
COPY x to stdout (freeze);
COPY x from stdin (format CSV, force_quote(a));
