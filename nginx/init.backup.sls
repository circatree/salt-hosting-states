nginx:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: nginx
      - file: /etc/nginx
      - file: /etc/nginx/htpasswd
      - file: /srv/www
    - watch:
      - file: /etc/nginx/timestamp

/etc/nginx/timestamp:
  file.managed:
    - source: salt://nginx/timestamp

/etc/nginx:
  file.recurse:
    - source: salt://nginx/config
    - user: root
    - group: root

/etc/nginx/htpasswd:
  file.recurse:
    - source: salt://nginx/htpasswd
    - user: www-data
    - group: www-data
    - dir_mode: 544
    - file_mode: 444

# /srv/www:
  # directory.exists
  # file.recurse:
    # - source: salt://nginx/webroot




