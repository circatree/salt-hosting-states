php-mysql-pkgs:
  pkg.installed:
    - name: php5-mysql

/etc/php5/fpm/conf.d/mysql.ini:
  file.managed:
    - source: salt://php/mysql/mysql.ini.jinja
    - template: jinja

/etc/php5/fpm/conf.d/mysqli.ini:
  file.managed:
    - source: salt://php/mysql/mysqli.ini.jinja
    - template: jinja
