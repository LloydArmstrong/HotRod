hotrodctl-install:
  file.managed:
    - name: /usr/local/bin/hotrodctl
    - makedirs: True
    - mode: 500
    - source: salt://hotrod/files/hotrodctl

    
hotrod-upstart-install:
  file.managed:
    - name: /etc/init/hotrod.conf
    - makedirs: True
    - mode: 500
    - source: salt://hotrod/files/hotrod.conf

    
  
  

  
  
