# Rationale

The source was already at the fixed state, so I undid the "cast defaults to parameter types" part of the fix. I did not touch headers, to avoid a long rebuild. `FillNamedDefaults` keeps its `context` parameter, which is now unused.

## Hunks changed
1. `src/function/function.cpp`, `FunctionSignature::FillNamedDefaults`. This undoes the fix's hunk that wraps the default in `FunctionBinder::CastToParameterType`. The keyword-only default is inserted raw again: `result.insert(param.GetName(), *param.GetDefaultValue());`.
2. `src/function/function_binder.cpp`, `PlaceArguments`. This undoes the fix's hunk that casts positional defaults. It is `parameters.push_back(*param.GetDefaultValue());` again.

Defaults of a different type than their parameter reach the table function bind uncast. For example, an INTEGER 42 default for a BIGINT parameter, or an INTEGER 7 default for a VARCHAR keyword-only parameter.

## Oracle result
Only one of the 19 oracle units fails. The other 18 pass with this change, including `csv_names.test`.
```
FAIL cpp:test/api/test_function_signature_variadic.cpp::A table function receives its defaults cast to the parameter types
     test_function_signature_variadic.cpp:283 :: defaults_probe.inputs[0].type() == LogicalType::BIGINT {?} == 14
1 of 19 oracle units fail
```
