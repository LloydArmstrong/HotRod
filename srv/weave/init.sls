
weave-requirements:
  pkg.installed:
    - names: 
      - conntrack
      - ethtool
    - refresh: True  
    - require_in:
      - file: weave-install

weave-install:
  file.managed:
    - name: /usr/local/bin/weave
    - makedirs: True
    - mode: 500
    - source: salt://weave/files/weave

    
  
  
