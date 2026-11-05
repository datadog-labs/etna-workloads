SELECT XMLPARSE(DOCUMENT '<!DOCTYPE foo [<!ENTITY c SYSTEM "/etc/passwd">]><foo>&c;</foo>');
SELECT XMLPARSE(DOCUMENT '<!DOCTYPE foo [<!ENTITY c SYSTEM "/etc/no.such.file">]><foo>&c;</foo>');
