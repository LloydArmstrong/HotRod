
hotrodctl:
  extends:
    file: common-services.yml
    service: hotrod-core
  build: hotrodctl
  environment:
    - constraint:master==true 
    - HOTROD_PROJNAME={{ hotrod_project_name }}         
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

