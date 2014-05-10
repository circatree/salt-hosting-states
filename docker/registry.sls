include:
  - python.pip

docker-py:
  pip.installed:
    - require:
      - sls: python.pip

docker_private_registry_image:
  docker.pulled:
    - name: shipyard/docker-private-registry

docker_private_registry_config_yml:
  file.managed:
    - name: /var/lib/docker-registry/config.yml
    - src: salt://docker/registry/config_sample.yml

