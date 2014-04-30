{% set sites_enabled = salt['pillar.get']('nginx:sites_enabled', ['default']) %}
{% set sites_disabled = salt['pillar.get']('nginx:sites_disabled', []) %}
{% set requirements = salt['grains.get']('requirements', []) %}
{% set tracelytics_enabled = 'tracelytics' in requirements %}

{% if tracelytics_enabled %}
include:
  - tracelytics.apt.sources
{% endif %}
{% if not tracelytics_enabled %}
nginx_stable_ppa:
  pkgrepo.managed:
    - ppa: nginx/stable
    - require_in:
      - pkg: nginx
{% endif %}

nginx_webroot:
  file.directory:
    - name: /srv/www
    - user: www-data
    - group: www-data
    - mode: 755

nginx:
  pkg:
    - name: nginx
    - installed
    {% if tracelytics_enabled %}
    - require:
      - sls: tracelytics.apt.sources
    {% endif %}
  service:
    - running
    - watch:
      - file: /etc/nginx/timestamp
      - file: /etc/nginx/nginx.conf
    - require:
      - file: /etc/nginx
      - file: /etc/nginx/htpasswd
      {% for sitename in sites_enabled %}
      - file: /etc/nginx/sites-available/{{ sitename }}
      - file: /etc/nginx/sites-enabled/{{ sitename }}
      {% endfor %}
      {% if sites_disabled %}
      {% for disabled_sitename in sites_disabled %}
      - file: /etc/nginx/sites-enabled/{{ disabled_sitename }}
      {% endfor %}
      {% endif %}

/etc/nginx:
  file.recurse:
    - source: salt://nginx/etc/nginx
    - user: root
    - group: root

/etc/nginx/nginx.conf:
  file.managed:
    - template: jinja
    - source: salt://nginx/templates/nginx.conf.jinja

/etc/nginx/timestamp:
  file.managed:
    - source: salt://nginx/etc/nginx/timestamp

/etc/nginx/htpasswd:
  file.recurse:
    - source: salt://nginx/etc/nginx/htpasswd
    - user: www-data
    - group: www-data
    - dir_mode: 544
    - file_mode: 444

{% set nginx_sites = pillar.get('nginx', {}).get('sites', {}) %}
{% for sitename in sites_enabled %}
{% set site = nginx_sites[sitename] %}
{{ sitename }}_webroot:
  file.directory:
    - name: {{ site.root }}
    - user: {{ site.owner }}
    - group: {{ salt['pillar.get']('nginx:web_user', 'www-data') }}
    - dir_mode: 750
    - file_mode: 640
    - makedirs: True
    - recurse:
      - mode
      - user
      - group

/etc/nginx/sites-available/{{ sitename }}:
  file.managed:
    - source: salt://nginx/templates/drupal-site.conf.jinja
    - template: jinja
    - context:
      site: {{ site }}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/{{ sitename }}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ sitename }}
{% endfor %}

{% if sites_disabled %}
{% for disabled_sitename in sites_disabled %}
/etc/nginx/sites-enabled/{{ disabled_sitename }}:
  file.absent
{% endfor %}
{% endif %}

{% set ssl = pillar.get('nginx', {}).get('ssl', {}) %}
{% if ssl %}
/etc/nginx/ssl:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755
    - makedirs: True

/etc/nginx/ssl/{{ ssl['cert_filename'] }}:
  file.managed:
    - source: salt://nginx/templates/cert.jinja
    - template: jinja
      - user: www-data
      - group: www-data
      - mode: 664
      - require:
        - pkg: nginx
        - file: /etc/nginx/ssl

/etc/nginx/ssl/{{ ssl['key_filename'] }}:
  file.managed:
    - source: salt://nginx/templates/key.jinja
    - template: jinja
    - user: www-data
    - group: www-data
    - mode: 660
    - require:
      - pkg: nginx
      - file: /etc/nginx/ssl
{% endif %}
