SET extension_control_path = '$system:$system';
SELECT count(*) - count(DISTINCT name) AS dups FROM pg_available_extensions;
SELECT count(*) - count(DISTINCT (name, version)) AS dups FROM pg_available_extension_versions;
