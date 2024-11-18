import boto3
import time
import notify2

TABLE_NAME = "cloudtrail_logs_2024"
S3_BUCKET = "aws-cloudtrail-logs-xxxxx"
CHANNEL_ID = "xxxxxxxxx" 
def has_query_succeeded(execution_id,region):
    CLIENT = boto3.client("athena",str(region))
    state = "RUNNING"
    max_execution = 10

    while max_execution > 0 and state in ["RUNNING", "QUEUED"]:
        max_execution -= 1
        response = CLIENT.get_query_execution(QueryExecutionId=execution_id)
        if (
            "QueryExecution" in response
            and "Status" in response["QueryExecution"]
            and "State" in response["QueryExecution"]["Status"]
        ):
            state = response["QueryExecution"]["Status"]["State"]
            if state == "SUCCEEDED":
                return True

        time.sleep(50)

    return False

def get_num_rows(Query,region,s3_location):
    CLIENT = boto3.client("athena",str(region))
    response = CLIENT.start_query_execution(
        QueryString=Query,
        ResultConfiguration={"OutputLocation": s3_location}
    )

    return response["QueryExecutionId"]

def get_query_results(execution_id,region):
    try:
        CLIENT = boto3.client("athena",str(region))
        response = CLIENT.get_query_results(
            QueryExecutionId=execution_id
        )
        results = response['ResultSet']['Rows']
    except Exception as error:
            return {'error': error}
        
    return results

def get_pemdeny_lst(YEAR,MONTH,DAY):
    RESULT_OUTPUT_LOCATION = "s3://aws-cloudtrail-logs-xxxxxxxx/queries/"
    QuickQuery = f"""SELECT count (*) as TotalEvents, useridentity.arn, eventsource
                FROM {TABLE_NAME}
                WHERE (errorcode like '%Denied%' or errorcode like '%Unauthorized%')
                and year = '{str(YEAR)}'
                and month = '{str(MONTH)}' 
                AND eventtime >= '{str(YEAR)}-{str(MONTH)}-{str(DAY)}T00:00:00Z' 
                AND eventtime < '{str(YEAR)}-{str(MONTH)}-{str(DAY)}T23:59:59Z'
                GROUP by eventsource,useridentity.arn
                ORDER by TotalEvents DESC"""

    print(f"Query String: {QuickQuery}")
    execution_result_id = get_num_rows(QuickQuery,region="ap-southeast-1",s3_location=RESULT_OUTPUT_LOCATION)
    print(f"Get Num Rows execution id: {execution_result_id}")

    query_status = has_query_succeeded(execution_id=execution_result_id,region="ap-southeast-1")
    print(f"Query state: {query_status}")

    # Query Results
    Query_results = get_query_results(execution_id=execution_result_id,region="ap-southeast-1")
    print(f"Query_results = {Query_results}")
    print(f"Down load Query Result on {RESULT_OUTPUT_LOCATION}{execution_result_id}.csv")


    # Make Slack Text 
    SlackText = ""
    for qresult in Query_results[1:]:
        SlackText = SlackText + "\nUser: " + qresult["Data"][1]["VarCharValue"].replace("arn:aws:iam::xxxxxxxxxx:",'') + "     AWSResource: " +  qresult["Data"][2]["VarCharValue"] + "    COUNT: " + qresult["Data"][0]["VarCharValue"] + "\n"

    print(f"SlackText:{SlackText}")


    ### Send to Slack 

    athena_report = "queries/{}.csv".format(execution_result_id)
    notify2.send_slack_msg(CHANNEL_ID,SlackText)
    notify2.send_slack_s3attach(S3_BUCKET,athena_report,CHANNEL_ID,"Please Download report","PermissionDenyReport")
    return {"SlckChannel":"xxxxxxxxxxx"}

def get_login_failed(YEAR,MONTH,DAY):
    RESULT_OUTPUT_LOCATION = "s3://aws-cloudtrail-logs-xxxxxx/queries/"
    QuickQuery = f"""SELECT *
                FROM {TABLE_NAME}
                WHERE eventname = 'ConsoleLogin' and errormessage = 'Failed authentication'
                and year = '{str(YEAR)}'
                and month = '{str(MONTH)}' 
                AND eventtime >= '{str(YEAR)}-{str(MONTH)}-{str(DAY)}T00:00:00Z' 
                AND eventtime < '{str(YEAR)}-{str(MONTH)}-{str(DAY)}T23:59:59Z'"""

    print(f"Query String: {QuickQuery}")
    execution_result_id = get_num_rows(QuickQuery,region="ap-southeast-1",s3_location=RESULT_OUTPUT_LOCATION)
    print(f"Get Num Rows execution id: {execution_result_id}")

    query_status = has_query_succeeded(execution_id=execution_result_id,region="ap-southeast-1")
    print(f"Query state: {query_status}")

    # Query Results
    Query_results = get_query_results(execution_id=execution_result_id,region="ap-southeast-1")
    print(f"Query_results = {Query_results}")
    print(f"Down load Query Result on {RESULT_OUTPUT_LOCATION}{execution_result_id}.csv")


    # Make Slack Text 
    SlackText = ""
    for qresult in Query_results[1:]:
        SlackText = SlackText + "\nUser: " + qresult["Data"][1]["VarCharValue"].replace("arn:aws:iam::xxxxxxxxxxx:",'') + "     AWSResource: " +  qresult["Data"][2]["VarCharValue"] + "    COUNT: " + qresult["Data"][0]["VarCharValue"] + "\n"

    print(f"SlackText:{SlackText}")

    ### Send to Slack 
    athena_report = "queries/{}.csv".format(execution_result_id)
    notify2.send_slack_msg(CHANNEL_ID,SlackText)
    notify2.send_slack_s3attach(S3_BUCKET,athena_report,CHANNEL_ID,"Please Download report","LoginFailed_report")
    return {"SlckChannel":"xxxxxxxxxxx"}

def get_waf_sql(YEAR,MONTH,DAY,COUNTRY):
    if COUNTRY == "jp":
        RESULT_OUTPUT_LOCATION = "s3://xxxxxxxxxxx/queries/"
        TABLE_NAME = "table_name"
        QREGION="ap-northeast-1"
        S3_BUCKET = "xxxxxxxxxxx"
    elif COUNTRY == "au":
        RESULT_OUTPUT_LOCATION = "s3://xxxxxxxxxxx/queries/"
        TABLE_NAME = "table_name"
        QREGION="ap-southeast-2"
        S3_BUCKET="xxxxxxxxxxx"
    QuickQuery = f"""WITH mytemp AS (
            SELECT
            count(*) AS count,
            httpsourceid,
            httprequest.clientip,
            httprequest.country,
            t.rulegroupid, 
            t.nonTerminatingMatchingRules
            FROM {TABLE_NAME}
            CROSS JOIN UNNEST(rulegrouplist) AS t(t) 
            WHERE action <> 'BLOCK' AND "date" = '{str(YEAR)}/{str(MONTH)}/{str(DAY)}'
            GROUP BY t.nonTerminatingMatchingRules, action, httpsourceid, httprequest.clientip, t.rulegroupid,httprequest.country
            ORDER BY "count" DESC 
            Limit 10 )
            select * from mytemp where rulegroupid like '%AWS#AWSManagedRules%' order by count DESC"""

    print(f"Query String: {QuickQuery}")
    execution_result_id = get_num_rows(QuickQuery,region=QREGION,s3_location=RESULT_OUTPUT_LOCATION)
    print(f"Get Num Rows execution id: {execution_result_id}")

    query_status = has_query_succeeded(execution_id=execution_result_id,region=QREGION)
    print(f"Query state: {query_status}")

    # Query Results
    Query_results = get_query_results(execution_id=execution_result_id,region=QREGION)
    print(f"Query_results = {Query_results}")
    print(f"Down load Query Result on {RESULT_OUTPUT_LOCATION}{execution_result_id}.csv")


    # # Make Slack Text 
    SlackText = ""
    for qresult in Query_results[1:]:
        SlackText = SlackText + "ALB_Name: " + qresult["Data"][1]["VarCharValue"].replace("arn:aws:iam::xxxxxxxxxxx:",'') + "     SQLInject_SrcIP: " +  qresult["Data"][2]["VarCharValue"] + "    COUNT: " + qresult["Data"][0]["VarCharValue"] + "\n"
    
    SlackText = "White IP list:\n(\n(xxxxxx - xxxxxx\n" + "\n-------------------------------\n\n" + SlackText
    print(f"SlackText:{SlackText}")

    # ### Send to Slack 
    athena_report = "queries/{}.csv".format(execution_result_id)
    notify2.send_slack_msg(CHANNEL_ID,SlackText)
    notify2.send_slack_s3attach(S3_BUCKET,athena_report,CHANNEL_ID,"Please Download report","WAF_SQLInject_report")
    return {"SlckChannel":"xxxxxxxxxxx"}

def get_top_ip(YEAR,MONTH,DAY,COUNTRY):
    if COUNTRY == "jp":
        RESULT_OUTPUT_LOCATION = "s3://xxxxxxxxxxx/queries/"
        TABLE_NAME = "table_name"
        QREGION="ap-northeast-1"
        S3_BUCKET = "xxxxxxxxxxx"
    elif COUNTRY == "au":
        RESULT_OUTPUT_LOCATION = "s3://xxxxxxxxxxx/queries/"
        TABLE_NAME = "table_name"
        QREGION="ap-southeast-2"
        S3_BUCKET="xxxxxxxxxxx"

    QuickQuery = f"""SELECT httprequest.clientip,COUNT(*) as count
            FROM {TABLE_NAME}
            WHERE "date" = '{str(YEAR)}/{str(MONTH)}/{str(DAY)}'
            GROUP BY httprequest.clientip
            HAVING COUNT(*) > 1000
            ORDER BY count DESC 
            Limit 20
            """

    print(f"Query String: {QuickQuery}")
    execution_result_id = get_num_rows(QuickQuery,region=QREGION,s3_location=RESULT_OUTPUT_LOCATION)
    print(f"Get Num Rows execution id: {execution_result_id}")

    query_status = has_query_succeeded(execution_id=execution_result_id,region=QREGION)
    print(f"Query state: {query_status}")

    # Query Results
    Query_results = get_query_results(execution_id=execution_result_id,region=QREGION)
    print(f"Query_results = {Query_results}")
    print(f"Down load Query Result on {RESULT_OUTPUT_LOCATION}{execution_result_id}.csv")

    # # Make Slack Text 
    SlackText = ""
    for qresult in Query_results[1:]:
        SlackText = SlackText +  "Client ip: " +  qresult["Data"][0]["VarCharValue"] + "    COUNT: " + qresult["Data"][1]["VarCharValue"] + "\n"
    
    SlackText = "White IP list:\n\n(xxxxxx - xxxxxx)\n" + "\n-------------------------------\n\n" + SlackText
    print(f"SlackText:{SlackText}")

    # ### Send to Slack 
    athena_report = "queries/{}.csv".format(execution_result_id)
    notify2.send_slack_msg(CHANNEL_ID,SlackText)
    notify2.send_slack_s3attach(S3_BUCKET,athena_report,CHANNEL_ID,"Please Download report","TOP 20 IP report")
    return {"SlckChannel":"xxxxxxxxxxx"}