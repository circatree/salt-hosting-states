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
  'roles:sshserver':
    - match: grain
    - ssh.server
  'roles:webserver':
    - match: grain
    - nginx
