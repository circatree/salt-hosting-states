include:
  - mysql

{% for db in salt['grains.get']('mysql:databases', []) %}
mysql_{{ db.name }}_db:
  mysql_database.present:
    - name: {{ db.name }}
{% endfor %}

