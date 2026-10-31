Subscripts ClassVar[Final[int]] and Final[ClassVar[int]]. Clean interpreter prints both reprs;
buggy one raises TypeError ("... is not valid as type argument") since allow_special_forms was removed.
