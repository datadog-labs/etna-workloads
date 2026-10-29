repro.sql formats a string with `%.0J` / `%.0j` (zero precision). The fixed shell
outputs `<"">` and `<>`; the buggy one treats precision 0 as unlimited and outputs
`<"abcdef">` and `<abcdef>`.
