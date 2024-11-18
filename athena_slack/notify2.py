import boto3
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
import os


LOCATE_REGION = "ap-southeast-1"
slack_token = "xoxb-xxxxxxx"
slack_client = WebClient(token=slack_token)
local_file_path = "/tmp/file.csv" 

def send_slack_msg(channel_id,slack_text):
    try:
        response = slack_client.chat_postMessage(
            channel=channel_id,
            text=slack_text
        )
        print(response)

    except SlackApiError as e:
        print(f"Error sending message: {e.response['error']}")


def send_slack_s3attach(bucket_name,s3_file_key,channel_id,slack_title,comment):

    s3_client = boto3.client('s3',LOCATE_REGION)
    s3_client.download_file(bucket_name, s3_file_key, local_file_path)
    try:
        response = slack_client.files_upload_v2(
            channels=channel_id,
            file=local_file_path,
            title="Result : {}".format(slack_title),
            # initial_comment="IAM Permission Deny List"
            initial_comment=str(comment)
        )
        print(response)
    except SlackApiError as e:
        print(f"Error uploading file: {e.response['error']}")
    finally:
        if os.path.exists(local_file_path):
           os.remove(local_file_path)
        print(f"Already Sent to channel:{channel_id}")