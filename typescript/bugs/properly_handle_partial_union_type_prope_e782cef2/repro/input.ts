function test1<T extends any[] | Record<string, any>>(obj: T) {
    if (Array.isArray(obj) || 'length' in obj) {
    } else {
        obj;
    }
}
function test3<T extends any[] | Record<string, any>>(obj: T) {
    if ('length' in obj) {
    } else {
        obj;
    }
}
