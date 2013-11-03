{% for groupname, group in pillar['groups'].iteritems() %}
{{ groupname }}:
  group:
    - exists
    {% if 'gid' in group %}
    - gid: {{ group['gid'] }}
    {% endif %}

{% endfor %}
