python-pip-pkg:
  pkg.installed:
    - name: python-pip
    - refresh: True
    - require_in:
      - cmd: update-pip
      
update-pip:
  cmd.run:
    - name: easy_install --upgrade pip

docker-py:
  pip.installed:
    - require:
      - pkg: python-pip