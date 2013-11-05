{% set hosts = pillar.get('hosts', []) %}

{% if hosts|count %}
{% for hostname, ip in hosts.items() %}
{{ hostname }}:
  host:
    - present
    - ip: {{ ip }}
{% endfor %}
{% endif %}


{% set absent_hosts = pillar.get('absent_hosts', []) %}

{% if absent_hosts|count %}
{% for hostname, ip in absent_hosts.items() %}
{{ hostname }}:
  host:
    - absent
    - ip: {{ ip }}
{% endfor %}
{% endif %}
