Feeds `<![CDATA[x]]>`, `<![if foo]>` and `<![endif]>` to HTMLParser (convert_charrefs=False).
The injected bug routes `<![` to parse_marked_section instead of handling CDATA only when
`_support_cdata` is set, so these are reported differently (unknown_decl vs bogus comment) than on clean.
Not verified by running: the Bash sandbox failed (bwrap missing <work>/repro/.claude/launch.json).
