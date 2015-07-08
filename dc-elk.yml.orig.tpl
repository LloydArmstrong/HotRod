elasticsearch:
  hostname: elasticsearch
  image: panoptix/elasticsearch:latest
  environment:
    - ES_HEAP_SIZE=3g
    - WEAVE_CIDR=169.254.50.1/24 169.254.51.1/24 169.254.52.1/24 169.254.53.1/24 169.254.54.1/24
  ports:
    - 127.0.0.1:9200:9200
    - 127.0.0.1:9300:9300
  labels:
    za.co.panoptix.hotrod.startorder: "0"
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"

kibana:
  hostname: kibana
  image: panoptix/kibana:kibana-4
  log_driver: none
  environment:
    - WEAVE_CIDR=169.254.50.2/24 
  ports:
    - 127.0.0.1:5601:5601
  extra_hosts:
    - elasticsearch:169.254.50.1
  labels:
    za.co.panoptix.hotrod.startorder: "1"
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"
     
rsyslog:
  hostname: rsyslog
  image: panoptix/rsyslog:elasticsearch
  environment:
    - WEAVE_CIDR=169.254.51.2/24
  extra_hosts:
    - elasticsearch:169.254.51.1
  ports:
    - 127.0.0.1:1514:514/tcp
  labels:
    za.co.panoptix.hotrod.startorder: "1"
    za.co.panoptix.hotrod.projectname: "{{ hotrod_project_name }}"
    

