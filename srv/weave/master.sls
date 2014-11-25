
launch_weave:
  cmd.run:
    - name: weave launch -password {{ pillar['weave']['shared_secret'] }}
    - unless: docker ps | egrep "\sweave\s+$"

