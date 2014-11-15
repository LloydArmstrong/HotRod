
launch_weave:
  cmd.run:
    - name: weave launch {{ grains['weave_ip'] }}/8 -password {{ pillar['weave']['shared_secret'] }}
    - unless: docker ps | egrep "\sweave\s+$"

