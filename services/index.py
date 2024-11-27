import json
import boto3
import os
import logging

session = boto3.Session(region_name=os.environ["REGION"])
dynamodb_client = session.client("dynamodb")


def lambda_handler(event, context):
    method = event["httpMethod"]
    try:
        if method == "POST":
            print("event ->" + str(event))
            payload = json.loads(event["body"])
            print("payload ->" + str(payload))
            required_fields = ["userId", "userName", "userClub"]
            # Verifica se os campos estão corretos
            for field in required_fields:
                if field not in payload:
                    return {
                        "statusCode": 400,
                        "body": json.dumps({"status": f"{field} is required"}),
                    }
            dynamodb_response = dynamodb_client.put_item(
                TableName=os.environ["TABLE_ARN"],
                Item={
                    "id": {"S": payload["userId"]},
                    "name": {"S": payload["userName"]},
                    "club": {"S": payload["userClub"]},
                },
            )
            print(dynamodb_response)
            return {"statusCode": 201, "body": '{"status":"User Created"}'}
        if method == "GET":
            user_id = event["queryStringParameters"].get("userId", None)
            if not user_id:
                return {
                    "statusCode": 400,
                    "body": json.dumps({"status": "userId is required"}),
                }
            print(f"Obtido user_id: {user_id}")
            dynamodb_response = dynamodb_client.get_item(
                TableName=os.environ["TABLE_ARN"], Key={"id": {"S": user_id}}
            )
            print(f"DynamoDB response: {json.dumps(dynamodb_response)}")
            if "Item" not in dynamodb_response:
                return {
                    "statusCode": 404,
                    "body": json.dumps({"status": f"User not found"}),
                }
            item = dynamodb_response["Item"]
            response_data = {
                "userId": item["id"]["S"],
                "userName": item["name"]["S"],
                "userClub": item["club"]["S"],
            }
            return {"statusCode": 200, "body": json.dumps(response_data)}
        return {
            "statusCode": 405,
            "body": json.dumps({"status": "Method Not Allowed"}),
        }
    except Exception as e:
        logging.error(e)
        return {"statusCode": 500, "body": '{"status":"Server error"}'}
