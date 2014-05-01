{% set requirements = salt['grains.get']('requirements', []) %}
{% set enable_tracelytics = 'tracelytics' in requirements and 0 %}

base:
  '*':
    - hosts
    - users
#    - vim
#    - postfix
  'os:Ubuntu':
    - match: grain
    - apt.sources.list
    - apt.update
    {% if enable_tracelytics %}
    - tracelytics
    - tracelytics.conf
    - tracelytics.apt.sources
    {% endif %}
  'roles:web-server':
    - match: grain
    - memcache
    - memcache.php
    - php
    - php.apc
    - php.fpm
    - php.fpm.memcache
    - php.mysql
    - nginx #tracelytics support is in nginx state.
  'roles:docker-host':
    - match: grain
    - docker.host
  'roles:jenkin-sserver':
    - match: grain
    - git
    - jenkins
  'roles:git-server':
    - match: grain
    - git.server
  'roles:ftpserver':
    - match: grain
    - ftp
  'roles:mysql-server':
    - match: grain
    - bin.inotify
    - bin.pwgen
    - mariadb
  'roles:ssh-server':
    - match: grain
    - ssh.server

  # Grains-derived requirements:
  'requirements:drush':
    - match: grain
    - php.drush
  'G@roles:web-server and G@roles:dev':
    - match: compound
    - php.drush
