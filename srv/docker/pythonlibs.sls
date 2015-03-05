python-pip-pkg:
  pkg.installed:
    - name: python-pip
    - refresh: True


docker-py:
  pip.installed:
    - require:
      - pkg: python-pip