salt-install-sh:
  file.managed:
    - name: /tmp/install_salt.sh
    - makedirs: True
    - mode: 0400
    - source: salt://salt/files/install_salt.sh
    
salt-install-sh-run:
  cmd.run:
    - name: |
        sh /tmp/install_salt.sh git v{{ pillar['saltversion'] }}
    - require_in:
      - file: saltmaster-config
      - file: grains-config
      - service: salt-minion-server
    - unless: salt --version | grep {{ pillar['saltversion'] }}
      
saltmaster-config:
  file.managed:
    - name: /etc/salt/minion.d/saltmaster.conf
    - makedirs: True
    - mode: 0400
    - source: salt://salt/files/saltmaster.conf
    
add_host_coresaltmaster:
  cmd.run:
    - name: |
        echo "127.0.0.1 coresaltmaster" >> /etc/hosts
    - unless: cat /etc/hosts | grep '127.0.0.1 coresaltmaster'
    - require_in: 
       - service: salt-minion-server
    
grains-config:
  file.managed:
    - name: /etc/salt/minion.d/grains.conf
    - makedirs: True
    - mode: 0400
    - template: jinja    
    - source: salt://salt/files/grains.conf    
    - context:
        weave_ip: {{ grains['weave_ip'] }}
        weave_master_ip: {{ grains['weave_master_ip'] }}
        weave_num: {{ grains['weave_num'] }}
        weave_sub: {{ grains['weave_sub'] }}
        
salt-minion-server:
  service:
    - running
    - name: salt-minion
    - enable: True
    - watch:
      - file: saltmaster-config
      - cmd: salt-install-sh-run

salt-minion-enabled:
  service.enabled:
    - name: salt-minion
    