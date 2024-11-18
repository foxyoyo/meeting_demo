import boto3
import notify
import requests

def unique(list1):
    list_set = set(list1)
    unique_list = (list(list_set))
    return unique_list

def Sum_Alaetmgm(LOCATE_REGION):

    if LOCATE_REGION == "ap-northeast-1":
        ALERTSERVER="https://prom.xxxxx.com/api/v1/alerts"
    elif LOCATE_REGION == "ap-southeast-2":
        ALERTSERVER="https://prom-2.xxxxx.com/api/v1/alerts"
        

    resp = requests.get(url=ALERTSERVER)
    resp_content = resp.json()
    # print(f"CW ALARM RESPONSE:{resp_content['data']['alerts']}, Type of rsponse:{type(resp_content['data']['alerts'])}")
    k8s_alarm_list = []
    for k8s_alarm in resp_content['data']['alerts']:
        if k8s_alarm["state"] == "firing":
           # print(f"alername:{k8s_alarm['labels']["alertname"]}")
           k8s_alarm_list.append(k8s_alarm['labels']["alertname"])

    return unique(k8s_alarm_list)

def Sum_cloudwatch_alarms(ALARM_TYPE,LOCATE_REGION):
    
    cw_client = boto3.client('cloudwatch',LOCATE_REGION)

    response = cw_client.describe_alarms(
        # StateValue='OK'|'ALARM'|'INSUFFICIENT_DATA',
        # StateValue='INSUFFICIENT_DATA',
        # StateValue=ALARM_TYPE,
        StateValue='ALARM',
        # ActionPrefix='string',
        MaxRecords=30
    )

    # print(f"CW ALARM RESPONSE:{response}, Type of rsponse:{type(response)}")
    # print(response['MetricAlarms'])
    # print(f"Type of {type(response['MetricAlarms'])} ,  list len : {len(response['MetricAlarms'])}")

    alarm_list = []
    if len(response['MetricAlarms']) > 0:
        for alarm_item in response['MetricAlarms']:
            # print(f"Region: {LOCATE_REGION} ,  AlarmName : {alarm_item["AlarmName"]}")
            alarm_list.append(alarm_item["AlarmName"])
    return alarm_list


def Get_alarm_report():

    PROD_REGION_LST=["ap-northeast-1","ap-southeast-2"]
    Sum_Result_dict={}
    for REGION in PROD_REGION_LST:
        DICT_KEY=REGION+"-CW"
        DICT_KEY_K8S=REGION+"-K8S"
        # Sum_Result_dict[DICT_KEY] = Sum_cloudwatch_alarms('INSUFFICIENT_DATA',REGION)
        Sum_Result_dict[DICT_KEY] = Sum_cloudwatch_alarms('ALARM',REGION)

        Sum_Result_dict[DICT_KEY_K8S] = Sum_Alaetmgm(REGION)

    # print(f"Result = {Sum_Result_dict}")

    ### Send to Slack 
    notify.Slack_channel(Sum_Result_dict)
    return {"SlckChannel":"foxtest"}