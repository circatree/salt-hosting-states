include:
  - bin.make
  - php.dev
  - php.pear
  - apt.update

php5:
  pkg.installed:
    - require:
      - sls: apt.update

{% if 'xhprof' in salt['grains.get']('requirements', []) %}
{% set xhprof_pkg_name = 'xhprof-0.9.2' if (salt['grains.get']('oscodename', '') == 'precise') else 'xhprof-0.9.4' %}
{{ xhprof_pkg_name }}:
  pecl.installed:
    - require:
      - sls: php.dev
      - sls: php.pear
{% endif %}
