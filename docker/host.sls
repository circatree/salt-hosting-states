import-docker-key:  
  cmd.run:
    - name: apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    - creates: /etc/apt/sources.list.d/docker.list
/etc/apt/sources.list.d/docker.list:
  file.managed:
    - source: salt://docker.list

docker-engine:
  pkg.installed

docker:
  service.running:
    - enabled: True
    - watch:
      - pkg: docker-engine
