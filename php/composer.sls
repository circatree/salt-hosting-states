include:
  - php
  - bin.wget

php-composer:
  cmd.run:
    - name: wget -L - http://getcomposer.org/installer | php
    - require:
      - sls: php
      - sls: bin.wget
