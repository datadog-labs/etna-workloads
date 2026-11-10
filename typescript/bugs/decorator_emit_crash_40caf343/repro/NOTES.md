Input: a class with a field decorator and a constructor parameter decorator (invalid under ES decorators, TS1206), compiled with target es2015 / commonjs, no experimentalDecorators.
Clean: reports TS1206 and emits the ES-decorator class transform normally.
Injected: the ES decorators transform wrongly collects constructor parameter decorators, so tsc crashes with "Debug Failure" (exit 1) and emits nothing.
