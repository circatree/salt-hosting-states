{% set os = grains['os'] %}
{% set oscodename = grains['oscodename'] %}
{% set version = pillar.get('mariadb_version', 10.0) %}
{% set rootpass = pillar.get('mariadb_rootpass', 'rootpass') %}

mariadb-server:

{% if os == 'Ubuntu' %}
  cmd.run:
    - name: apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/{{ version }}/ubuntu {{ oscodename }} main' && apt-get update

  {# Todo: this instead of above. Also use grain data to not make assumptions about OS!
  pkgrepo.managed:
    - humanname: mariadb-server-{{ version }}
    - name: deb http://ftp.osuosl.org/pub/mariadb/repo/{{ version }}/ubuntu {{ oscodename }} main
    - dist: {{ oscodename }}
    - keyid: 0xcbcb082a1bb943db
    - keyserver: hkp://keyserver.ubuntu.com:80
    - require_in:
      - pkg: mariadb-server
  cmd.run:
    - name: apt-get update
  #}

  debconf.set:
    - name: mariadb-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': {{ rootpass }} }
        'mysql-server/root_password_again': {'type': 'password', 'value': {{ rootpass }} }

{% endif %}

  pkg:
    - installed

{# @todo Implement this
/etc/mysql/my.cnf:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://mariadb/my.cnf
    - template: jinja
#}
