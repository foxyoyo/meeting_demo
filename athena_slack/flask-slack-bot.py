import slack
import flask_alarms
import tempfile
import athena
import uuid
import waf
import re
import logging

from datetime import datetime
from flask import Flask,make_response,jsonify,render_template,request
from slackeventsapi import SlackEventAdapter

# Fox-Personal #
SLACK_TOKEN = "xoxb-xxxxxxxxxxx"
SLACK_CHANNEL = "#k8s-xxxxxxx"
SIGNING_SECRET="xxxxxxxxxxxxxxxx"

app = Flask(__name__)

slack_event_adapter = SlackEventAdapter(SIGNING_SECRET, '/slack/events', app)
client = slack.WebClient(token=SLACK_TOKEN)

def save_request(uuid, request):
    req_data = {}
    req_data['uuid'] = uuid
    req_data['endpoint'] = request.endpoint
    req_data['method'] = request.method
    req_data['cookies'] = request.cookies
    req_data['data'] = request.data
    req_data['headers'] = dict(request.headers)
    req_data['headers'].pop('Cookie', None)
    req_data['args'] = request.args
    req_data['form'] = request.form
    req_data['remote_addr'] = request.remote_addr
    files = []
    for name, fs in request.files.items():
        dst = tempfile.NamedTemporaryFile()
        fs.save(dst)
        dst.flush()
        filesize = os.stat(dst.name).st_size
        dst.close()
        files.append({'name': name, 'filename': fs.filename, 'filesize': filesize,
         'mimetype': fs.mimetype, 'mimetype_params': fs.mimetype_params})
    req_data['files'] = files
    return req_data

@app.route('/')
def index():
    return 'OK'

@app.route('/slack/events', methods = ['POST'])
def slack_webhook():
    data = request.json
    print(data)
    my_challenge = request.json.get('challenge')
    mydata = {'challenge': my_challenge}
    return make_response(jsonify(mydata), 200)
    

@app.route('/mon/api/health')
def get_healt():
    return {
        "status" : "healthy",
        "log": "somewhere"
    }

@app.route('/mon/api/alarmlst', methods = ['POST'])
def get_alarms_lst():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            return flask_alarms.Get_alarm_report()
        except Exception as error:
            return {'error': error}

@app.route('/mon/api/pemdeny', methods = ['POST'])
def get_perm_deny():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data} , Request Args - {req_data['args']}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            app.logger.info(f"Receive args : Year = {req_data['args']['year']}, month = {req_data['args']['month']}, day = {req_data['args']['day']}")
            YEAR  = req_data['args']['year']
            MONTH = req_data['args']['month']
            DAY = req_data['args']['day']

            app.logger.info(f"Before Call Fun : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_pemdeny_lst(str(YEAR),str(MONTH),str(DAY))
        except Exception as error:
            return {'error': error}


@app.route('/mon/api/loginfail', methods = ['POST'])
def get_login_fail():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data} , Request Args - {req_data['args']}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            app.logger.info(f"Receive args : Year = {req_data['args']['year']}, month = {req_data['args']['month']}, day = {req_data['args']['day']}")
            YEAR  = req_data['args']['year']
            MONTH = req_data['args']['month']
            DAY = req_data['args']['day']

            app.logger.info(f"Before Call Fun : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_login_failed(str(YEAR),str(MONTH),str(DAY))
        except Exception as error:
            return {'error': error}

@app.route('/mon/api/waf', methods = ['POST'])
def get_waf_sql():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data} , Request Args - {req_data['args']}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            app.logger.info(f"Receive args : Year = {req_data['args']['year']}, month = {req_data['args']['month']}, day = {req_data['args']['day']}, region = {req_data['args']['region']} ")
            YEAR  = req_data['args']['year']
            MONTH = req_data['args']['month']
            DAY = req_data['args']['day']
            REGION = req_data['args']['region']
            app.logger.info(f"Before Call Fun : Year = {YEAR}, month = {MONTH}, day = {DAY}, region = {REGION}")
            return athena.get_waf_sql(str(YEAR),str(MONTH),str(DAY),str(REGION))
        except Exception as error:
            return {'error': error}

@app.route('/mon/api/topip', methods = ['POST'])
def get_waf_topip():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data} , Request Args - {req_data['args']}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            app.logger.info(f"Receive args : Year = {req_data['args']['year']}, month = {req_data['args']['month']}, day = {req_data['args']['day']}, region = {req_data['args']['region']} ")
            YEAR  = req_data['args']['year']
            MONTH = req_data['args']['month']
            DAY = req_data['args']['day']
            REGION = req_data['args']['region']
            app.logger.info(f"Before Call Fun : Year = {YEAR}, month = {MONTH}, day = {DAY}, region = {REGION}")
            return athena.get_top_ip(str(YEAR),str(MONTH),str(DAY),str(REGION))
        except Exception as error:
            return {'error': error}

@app.route('/mon/api/81badguy', methods = ['POST'])
def block_bad_ip():
    my_uuid = uuid.uuid1().hex
    req_data = save_request(my_uuid, request)
    # print(f"Receive Post! - {req_data}")
    app.logger.info(f"Receive Post! - {req_data} , Request Args - {req_data['args']}")
    auth_header = request.headers.get('H2-Token')
    if auth_header is None:
        print("Authorization header not found")
        return "auth header not found"
    else:
        try:
            app.logger.info(f"Header Token! - {auth_header}")
            app.logger.info(f"Receive args : badguy = {req_data['args']['ip']}, region = {req_data['args']['region']} ")
            BADGUY  = req_data['args']['ip']
            BADGUY = BADGUY.replace("-",".")
            BADGUY  = BADGUY + '/32'
            REGION = req_data['args']['region']
            app.logger.info(f"Before Call Fun : badguy = {BADGUY}, region = {REGION}")
            return waf.blockip(REGION,BADGUY)
        except Exception as error:
            return {'error': error}

@app.errorhandler(404)
def not_found(error):
    resp = make_response(render_template('error.html'), 404)
    resp.headers['X-Custom-Header'] = 'Fox-Test-1234'
    return resp

@slack_event_adapter.on("reaction_added")
def reaction_added(event_data):
  emoji = event_data["event"]["reaction"]
  print(emoji)

@slack_event_adapter.on("message")
def message(payload):
    print(payload)
    event = payload.get('event', {})
    channel_id = event.get('channel')
    user_id = event.get('user')
    text = event.get('text')
    thread_ts = ""
    if text.lower() == "help":
       client.chat_postMessage(channel=channel_id,text="Hello! \n show alarms \n show iamdeny \n show loginfail \n show jp_waf \n show au_waf \n show au_topip \n show jp_topip \n block_jp 99-99-99-99")

    if text.lower() == "show alarms":
        try:
            flask_alarms.Get_alarm_report()
            client.chat_postMessage(channel=channel_id,text="Already Send Alarm Result to Channel Sla Channel")
        except Exception as error:
            return {'error': error}
        
    if text.lower() == "show iamdeny":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_pemdeny_lst(str(YEAR),str(MONTH),str(DAY))
        except Exception as error:
            return {'error': error}
        
    if text.lower() == "show loginfail":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_login_failed(str(YEAR),str(MONTH),str(DAY))
        except Exception as error:
            return {'error': error}
        
    if text.lower() == "show jp_waf":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_waf_sql(str(YEAR),str(MONTH),str(DAY),"jp")
        except Exception as error:
            return {'error': error}
    if text.lower() == "show au_waf":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_waf_sql(str(YEAR),str(MONTH),str(DAY),"au")
        except Exception as error:
            return {'error': error}
    if text.lower() == "show au_topip":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_top_ip(str(YEAR),str(MONTH),str(DAY),"au")
        except Exception as error:
            return {'error': error}
    if text.lower() == "show jp_topip":
        try:
            now = datetime.now()
            YEAR = now.year
            MONTH = now.strftime('%m')
            DAY = now.strftime('%d')
            app.logger.info(f"Before Call SlackBot : Year = {YEAR}, month = {MONTH}, day = {DAY}")
            return athena.get_top_ip(str(YEAR),str(MONTH),str(DAY),"jp")
        except Exception as error:
            return {'error': error}
    # "block_jp 99-99-99-99":
    if  re.match('block_jp',text.lower()):
        try:
            match_result = re.search('(.*) (.*)',text.lower())
            BADGUY  = match_result.group(2).replace("-",".")
            BADGUY  = BADGUY + '/32'
            app.logger.info(f"BADGUY = {BADGUY} ,match 1 = {match_result.group(1)} , match 2 = {match_result.group(2)}")
            REGION = 'jp'
            app.logger.info(f"Before Call Fun : badguy = {BADGUY}, region = {REGION}")
            return waf.blockip(REGION,BADGUY)
        except Exception as error:
            return {'error': error}
    if  re.match('block_sg',text.lower()):
        try:
            match_result = re.search('(.*) (.*)',text.lower())
            BADGUY  = match_result.group(2).replace("-",".")
            BADGUY  = BADGUY + '/32'
            app.logger.info(f"BADGUY = {BADGUY} ,match 1 = {match_result.group(1)} , match 2 = {match_result.group(2)}")
            REGION = 'sg'
            app.logger.info(f"Before Call Fun : badguy = {BADGUY}, region = {REGION}")
            return waf.blockip(REGION,BADGUY)
        except Exception as error:
            return {'error': error}
    if  re.match('block_au',text.lower()):
        try:
            match_result = re.search('(.*) (.*)',text.lower())
            BADGUY  = match_result.group(2).replace("-",".")
            BADGUY  = BADGUY + '/32'
            app.logger.info(f"BADGUY = {BADGUY} ,match 1 = {match_result.group(1)} , match 2 = {match_result.group(2)}")
            REGION = 'au'
            app.logger.info(f"Before Call Fun : badguy = {BADGUY}, region = {REGION}")
            return waf.blockip(REGION,BADGUY)
        except Exception as error:
            return {'error': error}

if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True, port=6000)