{% set os = grains['os'] %}
{% set oscodename = grains['oscodename'] %}
{% set version = salt['pillar.get']('mysql:mariadb_version', 5.5) %}
{% set rootpass = salt['pillar.get']('mysql:mariadb_rootpass', 'rootpass') %}

mariadb-server:

{% if os == 'Ubuntu' %}

  cmd.run:
    - name: apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/{{ version }}/ubuntu {{ oscodename }} main' && apt-get update
    - unless: apt-key list | grep 1BB943DB 
    - require_in:
      - pkg: mariadb-server

  debconf.set:
    - name: mariadb-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': {{ rootpass }} }
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ rootpass }} }

  pkg:
    - installed

{% endif %}

/etc/mysql/my.cnf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://mysql/mariadb-{{ version }}-my.cnf.jinja
    - template: jinja

