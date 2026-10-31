Reverts both Lib/uuid.py hunks of the fix in main():
- `-n/--namespace` again uses `choices=["any UUID", *namespaces.keys()]` instead of `metavar`, so argparse rejects any custom UUID string as an invalid choice (the original bug: uuid3/uuid5 can't take a custom namespace UUID).
- The namespace lookup is again `namespaces[namespace] if namespace in namespaces else UUID(namespace)`, without the try/except that turns ValueError into parser.error.

Failing oracle cases: test_cli_uuid3/5_outputted_with_custom_namespace_and_name (argparse "invalid choice", SystemExit 2) and test_cli_uuid3/5_with_invalid_namespace (the choice "any UUID" passes argparse, then UUID() raises an uncaught ValueError instead of a parser error).
