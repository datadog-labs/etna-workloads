Runs `tsc --help --all` and greps for lines mentioning checkJs.
The description of the `allowJs` option reads "...Use the 'checkJs' option..." on the clean build.
The injected build prints 'checkJS' (wrong capitalisation) instead.
