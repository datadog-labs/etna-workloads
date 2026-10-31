Runs `uuid.main()` as the CLI with `-u uuid3 -n <custom UUID> -N python.org`.
Clean: prints the uuid3. Buggy: argparse `choices` rejects any non-predefined namespace (exit 2, "invalid choice").
