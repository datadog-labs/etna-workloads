Input: a class extending a base class whose overridden method uses `Position` from an ambient module "vscode" that is merged (augmented) in another file; a class-member-snippet completion is requested in the subclass.
Clean: completion entry details return the code action "Includes imports of types referenced by 'execActionWithCount'" with the `import { Position } from "vscode"` edit.
Injected: the module symbol is compared without getMergedSymbol, so getCompletionEntryDetails crashes with "Debug Failure. False expression."
