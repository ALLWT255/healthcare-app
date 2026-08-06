import boto3
import json

client = boto3.client(
    "secretsmanager",
    region_name="us-east-1"
)

def get_db_credentials():

    response = client.get_secret_value(
        SecretId="healthcare-db-credentials"
    )

    secret = json.loads(response["SecretString"])

    return secret