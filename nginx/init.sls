{% set sites = pillar.get('nginx', {}).get('sites', ['default']) %}
{% set sites_disabled = pillar.get('nginx', {}).get('sites_disabled', []) %}
{% if sites %}
nginx_stable_ppa:
  pkgrepo.managed:
    - ppa: nginx/stable
    - require_in:
      - pkg: nginx

/srv/www:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755

nginx:
  pkg:
    - name: nginx
    - installed
  service:
    - running
    - watch:
      - file: /etc/nginx/timestamp
    - require:
      - file: /etc/nginx
      - file: /etc/nginx/htpasswd
      - file: /srv/www/default
      {% for site in sites %}
      - file: /etc/nginx/sites-available/{{site}}
      - file: /etc/nginx/sites-enabled/{{site}}
      {% endfor %}
      {% for site in sites_disabled %}
      - file: /etc/nginx/sites-enabled/{{site}}
      {% endfor %}

/etc/nginx:
  file.recurse:
    - source: salt://etc/nginx
    - user: root
    - group: root

/etc/nginx/timestamp:
  file.managed:
    - source: salt://etc/nginx/timestamp

/etc/nginx/htpasswd:
  file.recurse:
    - source: salt://etc/nginx/htpasswd
    - user: www-data
    - group: www-data
    - dir_mode: 544
    - file_mode: 444

{% for site in sites %}
/etc/nginx/sites-available/{{site}}:
  file.managed:
    - source: salt://nginx/templates/site.jinja
    - template: jinja
    - context:
      site: {{site}}
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/{{site}}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{site}}
{% endfor %}

{% endif %}{# (end if sites) #}

{% for site in sites_disabled %}
/etc/nginx/sites-enabled/{{site}}:
    file.absent
{% endfor %}

{% set ssl = pillar.get('nginx', {}).get('ssl', {}) %}
{% if ssl %}
/etc/nginx/ssl:
    file.directory:
        - user: www-data
        - group: www-data
        - mode: 755
        - makedirs: True

/etc/nginx/ssl/{{ssl['cert_filename']}}:
    file.managed:
        - source: salt://etc/nginx/ssl/cert.jinja
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 664
        - require:
            - pkg: nginx
            - file: /etc/nginx/ssl

/etc/nginx/ssl/{{ssl['key_filename']}}:
    file.managed:
        - source: salt://etc/nginx/ssl/key.jinja
        - template: jinja
        - user: www-data
        - group: www-data
        - mode: 660
        - require:
            - pkg: nginx
            - file: /etc/nginx/ssl
{% endif %}
