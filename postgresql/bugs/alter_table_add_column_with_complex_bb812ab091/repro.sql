CREATE TABLE inhta ();
CREATE TABLE inhtb () INHERITS (inhta);
CREATE TABLE inhtc () INHERITS (inhtb);
CREATE TABLE inhtd () INHERITS (inhta, inhtb, inhtc);
ALTER TABLE inhta ADD COLUMN i int;
\d+ inhta
