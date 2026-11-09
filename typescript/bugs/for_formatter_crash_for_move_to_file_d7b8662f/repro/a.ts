export type ProblemKind =
  | "NoResolution"
  | "UntypedResolution"
  | "FalseESM"
  | "FalseCJS"
  | "CJSResolvesToESM"
  | "Wildcard"
  | "UnexpectedESMSyntax"
  | "UnexpectedCJSSyntax"
  | "FallbackCondition"
  | "CJSOnlyExportsDefault"
  | "FalseExportDefault";

export interface Problem {
  kind: ProblemKind;
  entrypoint: string;
}

export interface ProblemSummary {
  kind: ProblemKind;
  title: string;
  messages: {
    messageText: string;
    messageHtml: string;
  }[];
}
