import base64
import json
import boto3
import decimal

def lambda_handler(event, context):
    item = None
    table_name = " " # Insert dynamodb table name
    record_items = [] # Items of the coming records

    dynamo_db = boto3.resource('dynamodb')
    table = dynamo_db.Table(table_name)
    decoded_record_data = [base64.b64decode(record) for record in event['Records']] # Check the incoming format from kafka
    deserialized_data = [json.loads(decoded_record) for decoded_record in decoded_record_data]

    with table.batch_writer() as batch_writer:
        for item in deserialized_data:
            register = {i:item[i] for i in record_items}
            
            batch_writer.put_item(                        
                Item = register
            )
