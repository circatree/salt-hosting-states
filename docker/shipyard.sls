include:
  - docker.host

docker-shipyard-deploy-image:
  docker.pulled:
    - name: shipyard/shipyard-deploy

docker-shipyard-ufw-edit:
  file.replace:
    - name: /etc/default/ufw
    - pattern: ^DEFAULT_FORWARD_POLICY="DROP"
    - repl: DEFAULT_FORWARD_POLICY="ACCEPT"
  cmd.run:
    - name: ufw reload

# This is heavy handed.
# @todo Be a little nicer.
docker-shipyard-host-init-edit:
  file.replace:
    - name: /etc/default/docker
    - pattern: ^.*DOCKER_OPTS=$
    - repl: DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix://var/run/docker.sock"

docker-shipyard-host-etc-default-grub-edit:
  file.append:
    - name: /etc/default/grub
    - text: |
        # Enable memory and swap accounting
        # @see salt://docker/shipyard
        GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

# ``docker-shipyard-host-etc-default-grub-watch``:
# (TODO: update-grub (and reboot))

# Probably won't need this, or will need to adapt it heavily.
docker-shipyard-deploy-setup:
  cmd.run:
    - name: "docker run -d -t -v {{ salt['pillar.get']('docker.socket', '/var/run/docker.sock') }}:/docker.sock {{ salt['pillar.get']('docker.shipyard_opts', '') }} shipyard/deploy setup"
    - unless: docker ps | grep shipyard/shipyard
