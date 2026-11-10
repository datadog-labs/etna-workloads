function isHTMLTable<T extends object | null>(table: T): boolean {
    return !!table && 'html' in table;
}
