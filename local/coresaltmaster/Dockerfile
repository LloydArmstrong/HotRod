FROM panoptix/coresaltmaster

MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>
ENV REFRESHED_ON "13 Nov 2014"
ENV GIT_SSL_NO_VERIFY "true"

# This is project specific and only lives on a "live" hotrodmaster
RUN ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
RUN touch /tmp/hotrod

ADD remote_pillar.conf /etc/salt/master.d/
ADD remote_states.conf /etc/salt/master.d/
ADD hotrod-master.conf /etc/salt/master.d/
ADD kibanaproxy /master/local/kibanaproxy
ADD auth /master/local/auth
ADD adminauth /master/local/adminauth