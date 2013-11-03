{% for hostname, ip in pillar.get('hosts', []).items() %}
{{ hostname }}:
  host:
    - present
    - ip: {{ ip }}
{% endfor %}
