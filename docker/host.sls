{#
  Docker Host
  Currently with support for Ubuntu 12.04 and 13.04.
#}
{% if grains['os'] == 'Ubuntu' %}

{% if grains['oscodename'] == 'precise' %}
{#
  Backport raring kernel to Ubuntu 12.04 Precise.
  @see http://docs.docker.io/en/latest/installation/ubuntulinux/#ubuntu-precise
#}
docker-raring-backport-kernel:
  pkg.installed:
    - pkgs:
      - linux-image-generic-lts-raring
      - linux-headers-generic-lts-raring
{% endif %}

docker-pkg-key:
  cmd.run:
    - name: wget -qO- https://get.docker.io/gpg | apt-key add - && apt-get update
    - unless: apt-key list | grep A88D21E9

docker-apt-sources-list:
  file.managed:
    - name: /etc/apt/sources.list.d/docker.list
    - source: salt://docker/etc/apt/sources.list.d/docker.list

lxc-docker:
  pkg.installed:
    - require:
      - cmd: docker-pkg-key

{% endif %}