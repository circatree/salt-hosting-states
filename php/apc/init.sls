include:
  - apt.update

php-apc:
  pkg.installed:
    - require:
      - sls: apt.update

php5-apc-ini:
  file.managed:
    - name: /etc/php5/fpm/conf.d/apc.ini
    - source: salt://php/apc/apc.ini.jinja
    - template: jinja
