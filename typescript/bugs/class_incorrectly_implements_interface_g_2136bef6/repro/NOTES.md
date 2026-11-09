Input: a class `C implements ClickEventSupport`, where the interface is a mapped type with a template-literal `as` clause (names addClickListener/removeClickListener).
`repro.sh` runs the language service "Implement interface" code fix (error 2420) and prints the inserted members.
Clean: members are named `addClickListener` / `removeClickListener`. Injected: names are taken from the declaration's name node (the template/`K`), so the generated members are wrong.
