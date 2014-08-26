FROM ubuntu:14.04
MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>

ENV REFRESHED_ON "25 Aug 2014"

RUN apt-get update && apt-get -y install git python-jinja2 python-yaml python-pip
RUN pip install --upgrade fig

WORKDIR /tmp
RUN git clone https://github.com/panoptix-za/mini-templates.git

ADD default.yml /tmp/
ADD logger /tmp/logger
ADD up.sh /tmp/
RUN chmod a+x /tmp/up.sh

CMD /bin/bash
