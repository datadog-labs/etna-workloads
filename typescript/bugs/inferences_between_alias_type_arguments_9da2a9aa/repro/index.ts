
import * as lambdaTester from 'lambda-tester';
import { Handler } from 'aws-lambda';

type Actual = lambdaTester.Verifier<lambdaTester.HandlerResult<Handler>>;
type Expected = lambdaTester.Verifier<lambdaTester.HandlerResult<Handler<any, any>>>;