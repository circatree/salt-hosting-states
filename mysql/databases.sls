include:
  - mysql

{% for db in salt['grains.get']('mysql:databases', []) %}
mysql_{{ db.name }}_db:
  mysql.db_create:
    - name: {{ db.name }}
    {% if db.character_set is defined %}- character_set: {{ db.character_set }}{% endif %}
    {% if db.collate is defined %}- collate: {{ db.collate }}{% endif %}
{% endfor %}

