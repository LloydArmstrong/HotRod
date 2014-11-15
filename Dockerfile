FROM ubuntu:14.04.1
MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>

ENV REFRESHED_ON "15 Nov 2014"

RUN apt-get update && apt-get -y install git python-jinja2 python-yaml python-pip docker.io curl
RUN pip install --upgrade fig shyaml
RUN git clone https://github.com/panoptix-za/mini-templates.git

RUN mkdir -p /hotrod/

CMD /bin/bash
