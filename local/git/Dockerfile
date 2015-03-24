FROM panoptix/gitolite-http
MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>

COPY hotrod-composition.git /repositories/hotrod-composition.git
COPY hotrod-admin.git /repositories/hotrod-admin.git
COPY hotrod-projectfs.git /repositories/hotrod-projectfs.git

RUN htpasswd -cb /.htpasswd admin hotrod

