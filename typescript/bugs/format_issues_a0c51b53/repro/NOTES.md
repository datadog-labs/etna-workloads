Formats a class containing an optional property with initializer (`data? = {};`) via the language service's getFormattingEditsForDocument.
Clean build leaves `data? = {};` unchanged; the injected build deletes the space after `?`, producing `data?= {};`.
