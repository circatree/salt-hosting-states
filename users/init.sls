{% set roles = grains.get('roles', []) %}
{% for username, user in pillar['users'].iteritems() %}

{% if 'home' in user %}
{% set home = user.home %}
{% else %}
{% set home = '/home/%s' % username %}
{% endif %}
 
{# TODO: Implement this keep_modified_local_settings. #}
{% if 'keep_modified_local_settings' in user %}
{% set keep_modified_local_settings = user.keep_modified_local_settings %}
{% else %}
{% set keep_modified_local_settings = false %}
{% endif %}

user_skel:
  file.recurse:
    - name: /etc/skel
    - source: salt://users/etc/skel
    - user: root
    - group: root

{{ username }}:
  {% if 'gid' in user %}
  group.present:
    - gid: {{ user.gid }}
  {% endif %}
  user.present:
    - home: {{ home }}
    {% if 'uid' in user %}
    - uid: {{ user.uid }}
    {% endif %}
    {% if 'gid' in user %}
    - gid: {{ user.gid }}
    {% endif %}
    {% if 'shell' in user %}
    - shell: {{ user.shell }}
    {% endif %}
    {% if 'password' in user %}
    - password: {{ user.password }}
    {% endif %}
    {% if 'fullname' in user %}
    - fullname: {{ user.fullname }}
    {% endif %}
    {% if 'groups' in user %}
    - groups: {{ user.groups }}
    {% endif %}
    - require:
      - group: {{ username }}
    {% if 'group' in user %}
      - group: {{ user.group }}
    - group: {{ user.group }}
    {% endif %}

{{ home }}:
  {% if 'home_source' in user -%}
  file.recurse:
    - source: {{ user.home_source }}
    {% if 'home_dir_mode' in user %}
    - dir_mode: {{ user.home_dir_mode }}
    {% endif %}
    {% if 'home_file_mode' in user %}
    - file_mode: {{ user.home_file_mode }}
    {% endif %}
  {% else -%}
  file.directory:
  {% endif %}
    - user: {{ username }}
    {% if 'home_group' in user %}
    - group: {{ user.home_group }}
    {% else %}
    - group: {{ username }}
    {% endif %}
    {% if 'home_source' not in user %}
    - mode: 751
    {% endif %}
    - require:
      - user: {{ username }}

{#

{% if 'ssh_authorized_keys' in user %}

{{ home }}/.ssh:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - mode: 700
    - require:
      - user: {{ username }}
  
{% for keydata in user.ssh_authorized_keys %}
{{ username }}_authorized_key_{{ loop.index }}:
  ssh_auth:
    - present
    - user: {{ username }}
    - config: {{ home }}/.ssh/authorized_keys
    - require:
      - file: {{ home }}/.ssh
    {% if 'enc' in keydata %}
    - enc: {{ keydata.enc }}
    {% endif %}
    {% if 'key' in keydata %}
    - name: {{ keydata.key }}
    {% endif %}
    {% if 'comment' in keydata %}
    - comment: {{ keydata.comment }}
    {% endif %}
    {% if 'options' in keydata %}
    - options: {{ keydata.options }}
    {% endif %}
{% endfor %}

{% endif %}

{% if 'ssh_known_hosts' in user %}
{% for host, fingerprint in user.get('ssh_known_hosts', {}).items() %}
{{ host }}:
  ssh_known_hosts:
    - present
    - user: {{ username }}
    - fingerprint: {{ fingerprint }}
    - enc: ecdsa
{% endfor %}
{% endif %}

#}
   
{% if 'extended_state' in user %}
{% include user.extended_state %}
{% endif %}

{% endfor %}{# for username in pillar.users #}

{% for username in pillar.get('absent_users', []) %}
{{ username }}:
  user.absent
{% endfor %}
