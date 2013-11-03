vsftpd:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/vsftpd.conf
      - file: /etc/vsftpd.chroot_list

/etc/vsftpd.conf:
  file.managed:
    - source: salt://ftp/vsftpd.conf.jinja
    - template: jinja
    - require:
      - pkg.installed: vsftpd

/etc/vsftpd.chroot_list:
  file.managed:
    - source: salt://ftp/vsftpd.chroot_list
    - require:
      - pkg.installed: vsftpd

# vim:set ft=yaml:
