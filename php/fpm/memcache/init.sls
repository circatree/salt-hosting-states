php-fpm-memcache-ini:
  file.managed:
    - name: /etc/php5/fpm/conf.d/memcache.ini
    - source: salt://php/fpm/memcache/memcache.ini.jinja
    - mode: 664
