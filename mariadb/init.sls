mariadb-server:
  cmd.run:
    - name: apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu quantal main' && apt-get update

{#
  # Todo: this instead of above.
  pkgrepo.managed:
    - humanname: mariadb-server-10.0
    - name: deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu quantal main
    - dist: quantal
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
        'mysql-server/root_password': {'type': 'password', 'value': 'rootpass'}
        'mysql-server/root_password_again': {'type': 'password', 'value': 'rootpass'}

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

{# @todo Implement this (*maybe)
  # (This doesn't work.  Key doesn't get accepted.  Instead using manual commands above.)
#}
