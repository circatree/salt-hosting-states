
    - test
stfix:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: /etc/postfix/main.cf
            - cmd: make_sasl_password.db
            - cmd: make_generic.db
            - cmd: newaliases

/usr/local/bin/newer_than:
    file.managed:
        - source: salt://postfix/newer_than
        - user: root
        - group: root
        - mode: 755

mailutils:
    pkg:
        - installed
        - require:
            - pkg: postfix
            - cmd: newaliases

/etc/postfix:
    file.directory:
        - user: root
        - group: root
        - mode: 755
        - require:
            - pkg: postfix

/etc/postfix/main.cf:
    file.managed:
        - source: salt://postfix/main.cf.jinja
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: postfix
            - file: /etc/postfix

/etc/postfix/sasl_password:
    file.managed:
        - source: salt://postfix/sasl_password.jinja
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: postfix
            - file: /etc/postfix

make_sasl_password.db:
    cmd:
        - run
        - name: '/usr/sbin/postmap /etc/postfix/sasl_password'
        - cwd: /etc/postfix
        - onlyif: /usr/local/bin/newer_than /etc/postfix/sasl_password /etc/postfix/sasl_password.db
        - watch:
            - file: /etc/postfix/sasl_password
        - require:
            - pkg: postfix
            - file: /usr/local/bin/newer_than

/etc/postfix/generic:
    file.managed:
        - source: salt://postfix/generic.jinja
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: postfix
            - file: /etc/postfix

make_generic.db:
    cmd:
        - run
        - name: '/usr/sbin/postmap /etc/postfix/generic'
        - cwd: /etc/postfix
        - onlyif: /usr/local/bin/newer_than /etc/postfix/generic /etc/postfix/generic.db
        - watch:
            - file: /etc/postfix/generic
        - require:
            - pkg: postfix
            - file: /usr/local/bin/newer_than

/etc/aliases:
    file.managed:
        - source: salt://aliases
        - template: jinja
        - user: root
        - group: root
        - mode: 644
        - require:
            - pkg: postfix

newaliases:
    cmd:
        - run
        - name: /usr/bin/newaliases
        - onlyif: /usr/local/bin/newer_than /etc/aliases /etc/aliases.db
        - watch:
            - file: /etc/aliases
        - require:
            - pkg: postfix
            - file: /usr/local/bin/newer_than

