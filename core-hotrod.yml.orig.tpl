wproxy:
  image: weaveworks/weaveexec:1.0.1
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"
  net: host
  privileged: true
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /proc:/hostproc
  environment:
    - PROCFS=/hostproc
    - DOCKERHUB_USER=weaveworks
    - VERSION
    - WEAVE_DOCKER_ARGS
    - WEAVEDNS_DOCKER_ARGS
    - WEAVEPROXY_DOCKER_ARGS
    - WEAVE_PASSWORD
    - WEAVE_PORT
    - WEAVE_CONTAINER_NAME
    - DOCKER_BRIDGE
    - PROXY_HOST=127.0.0.1
    - WEAVE_CIDR=none
  command: --local launch-proxy --no-default-ipam -H tcp://0.0.0.0:12345 --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem

hotrodctl:
  build: hotrodctl
  net: host
  restart: always
#   environment:
#     - HOTROD_DEBUG=1 
  volumes:
    - /usr/local/bin:/usr/local/bin
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"



