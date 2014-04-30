apt-sources-list-file:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://apt/sources/sources.list.jinja
    - template: jinja
