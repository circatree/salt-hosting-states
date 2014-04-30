include:
  - apt.update

php5-fpm:
  pkg.installed:
    - require:
      - sls: apt.update

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
