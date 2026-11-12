.mode list
.nullvalue NULL
SELECT 'aaa' GLOB 'bbb';
SELECT 'aaa' GLOB 'aaa';
SELECT 'aaa' GLOB '*';
SELECT 'aaa' GLOB '*a';
SELECT 'aaa' GLOB '*b';
SELECT 'aaa' GLOB 'a*';
SELECT 'aaa' GLOB 'b*';
SELECT 'aaa' GLOB 'a?a';
SELECT 'aaa' GLOB 'a?';
SELECT 'aaa' GLOB '??*';
SELECT 'aaa' GLOB '????*';
SELECT 'ababac' GLOB '*abac';
SELECT '3' GLOB '[0-9]';
SELECT 'a' GLOB '[0-9]';
SELECT 'a' GLOB '[a-]', '-' GLOB '[a-]', 'b' GLOB '[a-]';
