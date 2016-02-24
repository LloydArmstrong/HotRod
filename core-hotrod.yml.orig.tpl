
hotrodctl:
  extends:
    file: common-services.yml
    service: hotrod-core
  image: panoptix/hotrod-hotrodctl:release-v0.3.0
  environment:
    - constraint:master==true 
    - HOTROD_PROJNAME={{ hotrod_project_name }}         
    - WEAVE_PASSWORD=${WEAVE_PASSWORD}
  net: host
  restart: always
  volumes:
    - /usr/local/bin:/usr/local/bin
    - /var/run/docker.sock:/var/run/docker.sock
    - /var/run/weave:/var/run/weave
  labels:
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

