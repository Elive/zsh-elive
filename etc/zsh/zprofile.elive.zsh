# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile"
fi

if [ -d /etc/zsh/zprofile.d ]; then
  for i in /etc/zsh/zprofile.d/*sh ; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

