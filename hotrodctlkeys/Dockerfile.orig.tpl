FROM ubuntu:14.04.2

ENV DOCKER_CERT_PATH /keys
ENV DOCKER_HOST tcp://127.0.0.1:12345
ENV HOTROD_PROJNAME {{ hotrod_project_name }}

COPY *.pem /keys/
VOLUME ["/keys"]

