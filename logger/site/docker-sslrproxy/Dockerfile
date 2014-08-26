FROM panoptix/sslrproxy

MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za
ENV REFRESHED_ON "26 Aug 2014"

# Generate SSL keys for each "project", this process can be improved _a lot_

RUN apt-get update
RUN apt-get -y install git

WORKDIR /tmp
RUN git clone https://github.com/OpenVPN/easy-rsa.git

#Insecure EasyRSA
WORKDIR /tmp/easy-rsa/easyrsa3
RUN ./easyrsa init-pki
RUN ./easyrsa --batch build-ca nopass
RUN ./easyrsa --batch build-server-full server nopass

RUN cp pki/private/server.key /tmp/server.key
RUN cp pki/issued/server.crt /tmp/server.pem
RUN cp pki/ca.crt /tmp/ca.crt

#Or add from local
#ADD ca.crt /tmp/
#ADD server.crt /tmp/server.pem
#ADD server.key /tmp/server.key


