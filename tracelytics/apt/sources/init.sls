/etc/apt/sources.list.d/tracelytics.list:
  file.managed:
    - source: salt://tracelytics/apt/sources/tracelytics.list.jinja
    - template: jinja
