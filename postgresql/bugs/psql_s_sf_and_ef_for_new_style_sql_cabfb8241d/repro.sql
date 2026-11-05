create function f1(int) returns int language sql return $1 + 1;
\sf+ f1
