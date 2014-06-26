include:
  - supervisor

salt-master:
  pkg:
    - latest
  file.exists:
    - name: /etc/salt/master
  supervisord.running:
    - restart: True
    - watch:
      - file: /etc/salt/master
      - file: /etc/supervisor/conf.d/salt-master.conf
    - require:
      - pkg: supervisor
      - file: /etc/supervisor/conf.d/salt-master.conf

/etc/supervisor/conf.d/salt-master.conf:
  file.managed:
    - source: salt://salt/master/salt-master_supervisor.conf
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/supervisor/conf.d
