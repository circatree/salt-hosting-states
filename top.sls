base:
  '*':
    - hosts
    - users
    - vim
  'roles:gitserver':
    - match: grain
    - git.server
  'roles:ftpserver':
    - match: grain
    - ftp
  'roles:mysqlserver':
    - match: grain
    - mariadb
  'roles:sshserver':
    - match: grain
    - ssh.server
  'roles:webserver':
    - match: grain
    - nginx
    - php
