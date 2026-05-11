// Replace placeholders with real values from `amplify pull` or CDK outputs.
const amplifyconfig = '''{
  "UserAgent": "aws-amplify-cli/2.0",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify-cli/0.1.0",
        "Version": "0.1.0",
        "IdentityManager": { "Default": {} },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "REPLACE_USER_POOL_ID",
            "AppClientId": "REPLACE_APP_CLIENT_ID",
            "Region": "us-east-1"
          }
        },
        "Auth": {
          "Default": {
            "authenticationFlowType": "USER_SRP_AUTH"
          }
        }
      }
    }
  },
  "api": {
    "plugins": {
      "awsAPIPlugin": {
        "ItemsRestApi": {
          "endpointType": "REST",
          "endpoint": "https://REPLACE.execute-api.us-east-1.amazonaws.com/prod",
          "region": "us-east-1",
          "authorizationType": "AMAZON_COGNITO_USER_POOLS"
        }
      }
    }
  }
}''';
