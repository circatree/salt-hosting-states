{% set requirements = salt['grains.get']('requirements', []) %}
{% set enable_tracelytics = 'tracelytics' in requirements %}

{#
  @todo Implement environments.
  @see http://docs.saltstack.com/en/latest/topics/tutorials/states_pt4.html
#}

base:
  '*':
    - salt.minion
    - users
    - hosts
    - vim
    - postfix
    - zsh.ohmy
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
    - nginx
  'roles:docker-host':
    - match: grain
    - docker.host
    - docker.fig
    - git
    - python.pip
    - python.dev
  'roles:jenkins-server':
    - match: grain
    - git
    - jenkins
    - php.composer
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
    - mysql
    - mysql.databases
  'roles:ssh-server':
    - match: grain
    - ssh.server
  'roles:salt-master:
    - match: grain
    - salt.master
    - salt.minion

  # Grains-derived requirements:
  'requirements:drush':
    - match: grain
    - php.drush
  'G@roles:web-server and G@roles:dev':
    - match: compound
    - php.drush
