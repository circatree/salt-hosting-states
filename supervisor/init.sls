supervisor:
  pkg.installed

/etc/supervisor/conf.d:
  file.directory:
    - user: root
    - group: root
    - mode: 660
    - makedirs: True
