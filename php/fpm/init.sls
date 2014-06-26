include:
  - apt.update
  - supervisor

php5-fpm:
  pkg.installed:
    - require:
      - sls: apt.update
  supervisor.running:
    - watch:
      - file: /etc/supervisor/conf.d/php5-fpm.conf

php5-fpm-php-ini:
  file.managed:
    - name: /etc/php5/fpm/php.ini
    - source: salt://php/etc/php5/fpm/php.ini.jinja
    - template: jinja

php5-fpm-conf:
  file.managed:
    - name: /etc/php5/fpm/php-fpm.conf
    - source: salt://php/etc/php5/fpm/php-fpm.conf.jinja
    - template: jinja

php5-fpm-pool-www:
  file.managed:
    - name: /etc/php5/fpm/pool.d/www.conf
    - source: salt://php/etc/php5/fpm/pool.d/www.conf.jinja
    - template: jinja

php5-fpm-supervisor-conf:
  file.managed:
    - name: /etc/supervisor/conf.d/php5-fpm.conf
    - source: salt://php/fpm/php5-fpm_supervisor.conf
    - template: jinja
    - owner: root
    - group: root
    - require:
      - pkg: supervisor
