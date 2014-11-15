python-pip-pkg:
  pkg.latest:
    - name: python-pip
    - refresh: True


docker-py:
  pip.installed:
    - require:
      - pkg: python-pip