{% set access_key = salt['pillar.get']('tracelytics:access_key', '0') %}
{% if access_key != '0' %}

include:
  - bin.wget
  - php

tracelytics-download:
  cmd.run:
    - name: wget https://www.tracelytics.com/install_tracelytics.sh
    - cwd: /tmp
    - require:
      - sls: bin.wget

tracelytics-install:
  cmd.run:
    - name: sh ./install_tracelytics.sh {{ access_key }}
    - cwd: /tmp

{% endif %}
