/etc/tracelytics.conf:
  file.managed:
    - source: salt://tracelytics/conf/tracelytics.conf.jinja
    - template: jinja
