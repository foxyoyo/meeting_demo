from signal import alarm
import urllib3 
import os
import json
http = urllib3.PoolManager() 

def lambda_handler(event, context): 
    alert_map = {
        "emoji": {
            "OK": ":white_check_mark:",
            "ALARM": ":fire:"
        },
        "text": {
            "OK": "RESOLVED",
            "ALARM": "FIRING"
        },
        "message": {
            "OK": "Everything is good!",
            "ALARM": "Stuff is burning!"
        },
        "color": {
            "OK": "#32a852",
            "ALARM": "#ad1721"
        },
        "wording": {
            "OK": "*_==== May the force be with you ====_*",
            "ALARM": "*_==You don't know the power of the dark side==_*"
        }  
    }  
    url = os.environ['SLACK_WEBHOOK_URL']
    alarm_msg = json.loads(event['Records'][0]['Sns']['Message'])
    alarm_name = alarm_msg['AlarmName']
    alarm_state = alarm_msg['NewStateValue']
    alarm_account = alarm_msg['AWSAccountId']
    alarm_region = alarm_msg['Region']
    alarm_desc = alarm_msg['NewStateReason']
    alarm_time = alarm_msg['StateChangeTime']
    alarm_emoj = alert_map["emoji"][alarm_state]
    alarm_text = alert_map["text"][alarm_state]
    msg = {
        "channel": os.environ['SLACK_WEBHOOK_CHANNEL'],
        "username": os.environ['SLACK_WEBHOOK_USERNAME'],
        "text": alert_map["wording"][alarm_state],
        "icon_emoji" : os.environ['SLACK_WEBHOOK_ICON'],
        "attachments": [
        {
            "color": alert_map["color"][alarm_state],
            "attachment_type": "default",
            "text": "{0} [*{1}*] \n *AWS Account :* {2} \n *AWS Region :* {7} \n *AlarmName :* {3} \n *Time :* {4} \n *status :* {5} \n *message :* {6} \n".format(alarm_emoj,alarm_text,alarm_account,alarm_name,alarm_time,alarm_state,alarm_desc,alarm_region),
            "actions": [
                {
                    "name": "CloudWatchAlarm",
                    "text": "Go to CloudWatch Alarm",
                    "type": "button",
                    "style": "primary",
                    "url": "https://ap-southeast-2.console.aws.amazon.com/cloudwatch/home?region=ap-southeast-2#alarmsV2:?"
                }]
        }
    ]
    }
    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)
    print({
        "message_output": json.loads(event['Records'][0]['Sns']['Message']),
        "AlarmName": alarm_name,
        "AlarmStatus" : alarm_state,
        "status_code": resp.status, 
        "response": resp.data
    })