declare enum Ext { X }
enum E { A = `a${Ext.X}`, B = "b" + Ext.X }
