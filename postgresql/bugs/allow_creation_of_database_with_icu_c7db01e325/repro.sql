CREATE DATABASE icu_sqlascii TEMPLATE template0 LOCALE_PROVIDER icu ICU_LOCALE 'en' ENCODING 'SQL_ASCII' LC_COLLATE 'C' LC_CTYPE 'C';
SELECT count(*) FROM pg_database WHERE datname='icu_sqlascii';
