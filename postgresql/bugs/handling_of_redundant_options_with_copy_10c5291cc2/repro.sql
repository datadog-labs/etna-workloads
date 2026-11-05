CREATE TABLE x (a int);
COPY x TO STDOUT (header off, header on);
COPY x TO STDOUT (freeze off, freeze on);
