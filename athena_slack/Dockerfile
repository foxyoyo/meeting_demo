FROM python:3.12.4
WORKDIR /usr/src/app
ADD ./requirements.txt /usr/src/app
ADD ./flask-slack-bot.py /usr/src/app
ADD ./flask_alarms.py /usr/src/app
ADD ./waf.py /usr/src/app
ADD ./notify.py /usr/src/app
ADD ./notify2.py /usr/src/app
ADD ./athena.py /usr/src/app
ADD ./templates /usr/src/app/templates
ADD ./run.sh /usr/src/app
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt-get clean
RUN apt-get update -y
RUN apt-get install sqlite3
RUN mkdir /usr/src/app/data
CMD [ "/bin/bash", "run.sh" ]