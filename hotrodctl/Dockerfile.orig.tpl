FROM ubuntu:14.04.2

ENV DOCKER_CERT_PATH /keys
ENV DOCKER_HOST tcp://127.0.0.1:12345
ENV HOTROD_PROJNAME {{ hotrod_project_name }}
ENV HOTROD_DEBUG 1

RUN apt-get update && apt-get -y install \
    curl
    
#Install Docker    
RUN curl -sSL https://get.docker.com/ubuntu/ | sudo sh

#Install Docker Compose


ADD keys /keys
ADD hotrodctl /usr/bin/hotrodctl
ENTRYPOINT ["/usr/bin/hotrodctl"]
CMD ["supervise"]