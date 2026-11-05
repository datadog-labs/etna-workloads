CREATE COLLATION ignore_accents (provider = icu, locale = 'und-u-ks-level1-kc-true', deterministic = false);
SELECT 'back\slash' COLLATE ignore_accents LIKE 'back\slash%' ESCAPE '#';
SELECT 'backslash' COLLATE ignore_accents LIKE 'back\\slash%';
