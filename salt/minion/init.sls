include:
  - supervisor

salt-minion:
  pkg:
    - latest
  file.exists:
    - name: /etc/salt/minion
  supervisord.running:
    - restart: True
    - watch:
      - file: /etc/salt/minion
      - file: /etc/supervisor/conf.d/salt-minion.conf
    - require:
      - pkg: supervisor
      - file: /etc/supervisor/conf.d/salt-minion.conf

/etc/supervisor/conf.d/salt-minion.conf:
  file.managed:
    - source: salt://salt/minion/salt-minion_supervisor.conf
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/supervisor/conf.d
