SELECT substr('abcdefg',0x100000001,2);
SELECT substr('abcdefg',1,0x100000002);
SELECT quote(substr(x'313233343536373839',0x7ffffffffffffffe,5));
