const {DynamoDBClient} = require("@aws-sdk/client-dynamodb");
const { GetCommand, DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = "MiTablaDynamoDB";

exports.handler = async (event) => {
  try {
    console.log("EVENT:", JSON.stringify(event));

    const id = event.queryStringParameters?.ID_Dron;

    if (!id) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: 'Missing ID_Dron in query parameters' }),
      };
    }

    const command = new GetCommand({
      TableName: TABLE_NAME,
      Key: {
        ID_Dron: id,
      },
    });

    const result = await ddb.send(command);

    if (!result.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: `Item with ID_Dron=${id} not found` }),
      };
    }

    return {
      statusCode: 200,
      body: JSON.stringify({ item: result.Item }),
    };

  } catch (error) {
    console.error('Error getting item from DynamoDB:', error);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal Server Error', error: error.message }),
    };
  }
};

