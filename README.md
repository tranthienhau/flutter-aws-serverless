# flutter-aws-serverless

Flutter mobile client wired to an existing AWS Serverless backend
(Lambda + API Gateway + DynamoDB + Cognito).

## What it shows

- Cognito User Pool sign-in via `amplify_auth_cognito`
- `Amplify.API` REST calls to API Gateway with the Cognito ID token attached
- Cognito User Pools authorizer enforced on each Lambda route
- DynamoDB table owned by `ownerSub` (multi-tenant by user)
- Mobile-friendly endpoints: `GET /items`, `POST /items`, `GET /items/{id}`, `DELETE /items/{id}`
- Riverpod state, `go_router` redirect-based auth gating
- "Skeleton app demonstrating successful communication with the backend" target

## App stack

- Flutter + Riverpod + go_router
- `amplify_flutter`, `amplify_auth_cognito`, `amplify_api`

## Infra stack

- AWS CDK (TypeScript) - `infra/cdk/stack.ts`
- Lambda handler - `infra/lambda/items.js` (AWS SDK v3 DynamoDB Document Client)

## Audit-phase fit (Job 7, Phase 1)

- M1 (Backend takeover & security audit): IAM least-privilege from `table.grantReadWriteData(fn)`, auth via Cognito authorizer, multi-tenant key.
- M2 (API alignment & mobile optimization): mobile JSON shape, pay-per-request DynamoDB, fast cold start (Node 20).
- M3 (App architecture & skeleton): Flutter app demonstrates connectivity end-to-end.

## Run

```
# Infra (replace stack values into lib/core/amplify_config.dart after deploy)
cd infra/cdk && npx cdk deploy

# App
flutter pub get
flutter run
```
