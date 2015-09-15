FROM ubuntu:14.04.2

ENV DOCKER_CERT_PATH /keys
ENV DOCKER_HOST tcp://127.0.0.1:12345
ENV HOTROD_PROJNAME {{ hotrod_project_name }}
{%- if http_proxy %}
ENV HTTP_PROXY {{ http_proxy }}
ENV http_proxy {{ http_proxy }}
{%- endif %}    
{%- if https_proxy %}
ENV HTTPS_PROXY {{ https_proxy }}
ENV https_proxy {{ http_proxy }}
{%- endif %}    

{%- if http_proxy %}
RUN echo "Acquire::http::Proxy \"{{ http_proxy }}\";"  > /etc/apt/apt.conf.d/01proxy
{%- endif %}    

RUN apt-get update && apt-get -y install \
    curl \
    wget
    
#Install Docker    
RUN curl --proxy-ntlm -sSL https://get.docker.com/gpg | sudo apt-key add -
RUN curl --proxy-ntlm -sSL https://get.docker.com/ | sh

#Install Docker Compose

ADD hotrodctl /usr/bin/hotrodctl
ENTRYPOINT ["/usr/bin/hotrodctl"]
CMD ["supervise"]

