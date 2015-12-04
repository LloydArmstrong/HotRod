
hotrodctl:
  extends:
    file: common-services.yml
    service: hotrod-core
  image: panoptix/hotrod-hotrodctl:release-v0.1.3
  environment:
    - constraint:master==true 
    - HOTROD_PROJNAME={{ hotrod_project_name }}         
  net: host
  restart: always
  volumes:
    - /usr/local/bin:/usr/local/bin
    - /var/run/docker.sock:/var/run/docker.sock
    - /var/run/weave/weave.sock:/var/run/weave/weave.sock
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

