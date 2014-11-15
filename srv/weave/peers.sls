{% if grains['weave_master_ip'] not in grains['ipv4'] %}

launch_weave_peer:
  cmd.run:
    - name: |
        /usr/local/bin/weave launch {{ grains['weave_ip'] }}/8 -password {{ pillar['weave']['shared_secret'] }} \
        {{ grains['weave_master_ip'] }} 
    - unless: docker ps | egrep "\sweave\s+$"

{% endif %}

attach_weave_minion:
  cmd.run:
    - name: |
        /usr/local/bin/weave expose 172.16.{{ grains['weave_sub'] }}.{{ grains['weave_num'] }}/24
    - unless: ifconfig weave | grep 'inet addr'