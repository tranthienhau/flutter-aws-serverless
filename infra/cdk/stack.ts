import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import * as ddb from "aws-cdk-lib/aws-dynamodb";
import * as lambda from "aws-cdk-lib/aws-lambda";
import * as apigw from "aws-cdk-lib/aws-apigateway";
import * as cognito from "aws-cdk-lib/aws-cognito";
import * as path from "node:path";

export class ServerlessStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const pool = new cognito.UserPool(this, "Users", {
      selfSignUpEnabled: true,
      signInAliases: { email: true },
      passwordPolicy: { minLength: 8 },
    });
    const client = pool.addClient("MobileClient", {
      authFlows: { userSrp: true },
      preventUserExistenceErrors: true,
    });

    const table = new ddb.Table(this, "Items", {
      partitionKey: { name: "ownerSub", type: ddb.AttributeType.STRING },
      sortKey: { name: "id", type: ddb.AttributeType.STRING },
      billingMode: ddb.BillingMode.PAY_PER_REQUEST,
    });

    const fn = new lambda.Function(this, "ItemsFn", {
      runtime: lambda.Runtime.NODEJS_20_X,
      handler: "items.handler",
      code: lambda.Code.fromAsset(path.join(__dirname, "../lambda")),
      environment: { ITEMS_TABLE: table.tableName },
    });
    table.grantReadWriteData(fn);

    const api = new apigw.RestApi(this, "ItemsApi");
    const auth = new apigw.CognitoUserPoolsAuthorizer(this, "Auth", { cognitoUserPools: [pool] });
    const integ = new apigw.LambdaIntegration(fn);
    const items = api.root.addResource("items");
    items.addMethod("GET", integ, { authorizer: auth });
    items.addMethod("POST", integ, { authorizer: auth });
    const one = items.addResource("{id}");
    one.addMethod("GET", integ, { authorizer: auth });
    one.addMethod("DELETE", integ, { authorizer: auth });

    new cdk.CfnOutput(this, "UserPoolId", { value: pool.userPoolId });
    new cdk.CfnOutput(this, "AppClientId", { value: client.userPoolClientId });
    new cdk.CfnOutput(this, "ApiUrl", { value: api.url });
  }
}
