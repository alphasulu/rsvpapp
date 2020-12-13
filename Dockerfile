FROM teamcloudyuga/python:alpine
COPY . /usr/src/app
WORKDIR /usr/src/app
ENV LINK http://www.meetup.com/cloudyuga/
ENV TEXT1 CloudYuga
ENV TEXT2 Garage RSVP!
ENV LOGO https://raw.githubusercontent.com/cloudyuga/rsvpapp/master/static/cloudyuga.png
ENV COMPANY CloudYuga Technology Pvt. Ltd.
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN pip3 install ptvsd
CMD python -m ptvsd --host 0.0.0.0 --port 9000 rsvp.py
