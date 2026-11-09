import * as pluginImportX from 'eslint-plugin-import-x'

interface Plugin {
  configs?: Record<string, { parser: string | null }>
}

const p: Plugin = pluginImportX;
