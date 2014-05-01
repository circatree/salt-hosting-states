include:
  - docker.host
  - python.pip

fig-installed:
  cmd.run:
    - name: pip install -U fig
    - unless: fig --version
    - require:
      - sls: python.pip
      - sls: docker.host
