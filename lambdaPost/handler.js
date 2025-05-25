const {DynamoDBClient}  = require("@aws-sdk/client-dynamodb");
const { PutCommand, DynamoDBDocumentClient} = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);

const TABLE_NAME = "MiTablaDynamoDB";

exports.handler = async (event) =>  {
  try {
    console.log("EVENT:", JSON.stringify(event));

    // Quita validación de método HTTP
    const body = JSON.parse(event.body);

    if (!body.ID_Dron) {
      body.ID_Dron = Date.now().toString(); 
    }

    const command = new PutCommand({
      TableName: TABLE_NAME,
      Item: body,
    });

    await ddb.send(command);

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Item saved successfully', item: body }),
    };

  } catch (error) {
    console.error('Error saving item to DynamoDB:', error);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal Server Error', error: error.message }),
    };
  }
}
