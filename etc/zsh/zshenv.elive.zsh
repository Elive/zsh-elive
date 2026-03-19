# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv"
fi

# Prepend special needed path's:
# ccache bins
path=(/usr/lib/ccache(N) $path)

# add or remove games entry if we are in the group
if (( ${(kM)#usergroups:#games} )) ; then
    path=(/usr/games(N) $path)
else
    path=( ${path:#/usr/games} )
fi

# support snaps
path=(/snap/bin(N) $path)
# support flatpaks
path=(/var/lib/flatpak/exports/bin(N) $path)
path=($HOME/.local/share/flatpak/exports/bin(N) $path)
# local nix packages
path=($HOME/.nix-profile/bin(N) $path)

# elive dev paths
path=(/opt/elive-dev_*/bin(N) $path)

# Go support
path=($HOME/go/bin(N) $path)

# NPM support
# local generic npm
path=($HOME/node_modules/.bin(N) $path)

# locally-installed npm packages:
# NPM packages in homedir
NPM_PACKAGES="$HOME/.npm-packages"

# Tell our environment about user-installed node tools
path=($HOME/.npm-packages/bin(N) $path)
# Unset manpath so we can inherit from /etc/manpath via the `manpath` command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your configuration
if [[ -x /usr/bin/manpath ]] ; then
    MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi

# Tell Node about these packages
NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"

# ruby gems
path=($HOME/.gem/ruby/*/bin(N) $path)
path=($HOME/.local/share/gem/ruby/*/bin(N) $path)

# user bin dirs
path=($HOME/packages/bin(N) $path)
path=($HOME/.local/bin(N) $path)
path=($HOME/bin(N) $path)

# Variables
export GPG_TTY=$(tty)
export CONFIG_SHELL="/bin/bash"
export EL_DEBUG=2

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath PATH

