# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8309f3f86da8103f53193b218cabe4b904550b4a ("Hide duplicate names from extension views"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/extension.c

Failing oracle cases:
- `src/test/modules/test_extensions|t/001_extension_control_path.pl|extension is installed correctly on pg_available_extension_versions`
- `src/test/modules/test_extensions|t/001_extension_control_path.pl|extension is installed correctly on pg_available_extensions`
