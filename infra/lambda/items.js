// Single Lambda behind API Gateway routes /items{+proxy}
// Auth: Cognito User Pool authorizer. DynamoDB table = ITEMS_TABLE.
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, GetCommand, PutCommand, DeleteCommand, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const ddb = DynamoDBDocumentClient.from(new DynamoDBClient({}));
const TABLE = process.env.ITEMS_TABLE;

const ok = (body, code = 200) => ({
  statusCode: code,
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(body),
});

exports.handler = async (event) => {
  const sub = event.requestContext?.authorizer?.claims?.sub;
  if (!sub) return ok({ message: "unauthorized" }, 401);
  const method = event.httpMethod;
  const path = event.path;
  const id = event.pathParameters?.id;

  try {
    if (method === "GET" && path === "/items") {
      const r = await ddb.send(new ScanCommand({
        TableName: TABLE,
        FilterExpression: "ownerSub = :s",
        ExpressionAttributeValues: { ":s": sub },
      }));
      return ok(r.Items ?? []);
    }
    if (method === "GET" && id) {
      const r = await ddb.send(new GetCommand({ TableName: TABLE, Key: { id, ownerSub: sub } }));
      if (!r.Item) return ok({ message: "not found" }, 404);
      return ok(r.Item);
    }
    if (method === "POST" && path === "/items") {
      const body = JSON.parse(event.body || "{}");
      const item = { id: body.id, ownerSub: sub, name: body.name, qty: body.qty ?? 0, createdAt: Date.now() };
      await ddb.send(new PutCommand({ TableName: TABLE, Item: item }));
      return ok(item, 201);
    }
    if (method === "DELETE" && id) {
      await ddb.send(new DeleteCommand({ TableName: TABLE, Key: { id, ownerSub: sub } }));
      return ok({ ok: true });
    }
    return ok({ message: "not allowed" }, 405);
  } catch (e) {
    return ok({ message: e.message }, 500);
  }
};
