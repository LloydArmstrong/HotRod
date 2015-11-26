wproxy:
  extends:
    file: common-services.yml
    service: hotrod-core
  image: weaveworks/weaveexec:1.0.2
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
  volumes_from:
    - hotrodctlkeys
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

