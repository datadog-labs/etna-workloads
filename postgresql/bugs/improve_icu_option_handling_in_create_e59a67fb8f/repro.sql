CREATE DATABASE t1 TEMPLATE template0 LOCALE_PROVIDER icu ICU_LOCALE 'en-US';
CREATE DATABASE t2 TEMPLATE t1 ICU_LOCALE 'en-US';
SELECT datname, datlocprovider, daticulocale FROM pg_database WHERE datname='t2';
