printf 'int main(void)\n\173\nEXEC SQL SELECT B'"'101'"', X'"'1F'"';\nreturn 0;\n\175\n' > t.pgc
ecpg -o - t.pgc 2>&1 | grep -i -E "SELECT|invalid|error"
rm -f t.pgc
