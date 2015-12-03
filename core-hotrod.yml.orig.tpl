# wproxy:
#   extends:
#     file: common-services.yml
#     service: hotrod-core
#   image: weaveworks/weaveexec:1.3.1
#   labels:
#     za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"
#   net: host
#   privileged: true
#   volumes:
#     - /var/run/docker.sock:/var/run/docker.sock
#     - /proc:/hostproc
#   environment:
#     - PROCFS=/hostproc 
#     - DOCKERHUB_USER=weaveworks 
#     - WEAVE_VERSION 
#     - WEAVE_DEBUG 
#     - WEAVE_DOCKER_ARGS 
#     - WEAVEPROXY_DOCKER_ARGS 
#     - WEAVE_PASSWORD 
#     - WEAVE_PORT 
#     - WEAVE_CONTAINER_NAME 
#     - WEAVE_MTU 
#     - WEAVE_NO_FASTDP 
#     - DOCKER_BRIDGE 
#     - SCRIPT_VERSION=1.3.1
#     - IMAGE_VERSION=1.3.1
#     - BASE_EXEC_IMAGE=weaveworks/weaveexec
#     - EXEC_IMAGE=weaveworks/weaveexec:1.3.1    
# #     - DOCKER_CLIENT_HOST=tcp://{{ weave_master_ip }}:2376 
#     - DOCKER_CLIENT_TLS_VERIFY=1 
#     - DOCKER_CLIENT_ARGS 
# #     - PROXY_HOST={{ weave_master_ip }}
#     - WEAVE_CIDR=none
#   command: --local launch-proxy --no-default-ipalloc --no-rewrite-hosts --without-dns -H /var/run/weave/weave.sock -H 0.0.0.0:12345 --tlsverify --tlscacert /etc/docker/ca.pem --tlscert /etc/docker/server.pem --tlskey /etc/docker/server-key.pem
#   

hotrodctlkeys:
  build: hotrodctlkeys
  environment:
    - constraint:master==true    
  container_name: hotrodctlkeys

hotrodctl:
  extends:
    file: common-services.yml
    service: hotrod-core
  build: hotrodctl
  environment:
    - constraint:master==true  
  net: host
  restart: always
  volumes:
    - /usr/local/bin:/usr/local/bin
    - /var/run/docker.sock:/var/run/docker.sock
    - /var/run/weave/weave.sock:/var/run/weave/weave.sock
#   volumes_from:
#     - hotrodctlkeys
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

