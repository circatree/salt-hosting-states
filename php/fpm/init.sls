include:
  - apt.update
  - supervisor

php-fpm:
  pkg.installed:
    - name: php5-fpm
    - require:
      - sls: apt.update
  supervisord.running:
    - watch:
      - file: /etc/php5/fpm/php.ini
      - file: /etc/php5/fpm/php-fpm.conf
      - file: /etc/php5/fpm/pool.d/www.conf
      - file: /etc/supervisor/conf.d/php-fpm.conf

/etc/php5/fpm/php.ini:
  file.managed:
    - source: salt://php/etc/php5/fpm/php.ini.jinja
    - template: jinja

/etc/php5/fpm/php-fpm.conf:
  file.managed:
    - source: salt://php/etc/php5/fpm/php-fpm.conf.jinja
    - template: jinja

/etc/php5/fpm/pool.d/www.conf:
  file.managed:
    - source: salt://php/etc/php5/fpm/pool.d/www.conf.jinja
    - template: jinja

/etc/supervisor/conf.d/php-fpm.conf:
  file.managed:
    - source: salt://php/fpm/php-fpm_supervisor.conf
    - template: jinja
    - owner: root
    - group: root
    - require:
      - pkg: supervisor
