memcache:
  pkg.installed:
    - require:
      - sls: apt.update
