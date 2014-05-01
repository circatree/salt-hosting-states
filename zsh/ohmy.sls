oh-my-zsh:
  cmd.run:
    - name: curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
    - unless: which zsh
