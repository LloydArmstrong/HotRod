FROM ubuntu:14.04.2
MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>

ENV REFRESHED_ON "25 Mar 2015"

RUN apt-get update && \
    apt-get -y install \
      curl \
      git \
      ldap-utils \
      python-jinja2 \
      python-pip \
      python-yaml 

#install Docker
RUN curl -sSL https://get.docker.com/ubuntu/ | sudo sh

RUN pip install --upgrade \
      fig \
      shyaml

RUN git clone https://github.com/panoptix-za/mini-templates.git

CMD /bin/bash
