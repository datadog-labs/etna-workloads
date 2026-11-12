PREPARE q AS SELECT $aa + $bb + $cc + $dd + $ee + $ff + $gg;
EXECUTE q(aa := 1);
