# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile"
fi

if [ -d /etc/zsh/zprofile.d ]; then
  for i in /etc/zsh/zprofile.d/*.sh ; do
      # note: do not use "if executable", some ones are not, like the one put by live-build scripts
      if [ -r "$i" ]; then
          zsh "$i"
      fi
  done
  unset i
fi

