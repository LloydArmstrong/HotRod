hotrodctl-install:
  file.managed:
    - name: /usr/local/bin/hotrodctl
    - makedirs: True
    - mode: 500
    - source: salt://hotrod/files/hotrodctl

    
  
  
