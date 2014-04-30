include:
  - php.pear

drush-pear-channel:
  cmd.run:
    - name: "pear channel-discover pear.drush.org"
    - unless: "pear list-channels | grep pear.drush.org"
    - require:
      - sls: php.pear

drush-pear-package:
  cmd.run:
    - name: "pear install drush/drush"
    - unless: "which drush"
    - require:
      - sls: php.pear
