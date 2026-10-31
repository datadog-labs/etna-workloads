from _pyrepl.reader import Reader

for ps1 in [">>> ", "\033[0;32m>>> \033[0m", "\001\033[0;32m\002>>> \001\033[0m\002",
            "\001\033[0;32m\002樂>\001\033[0m\002> "]:
    print(repr(Reader.process_prompt(ps1)))
