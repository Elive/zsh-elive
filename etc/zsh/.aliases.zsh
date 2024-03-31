# apt* related stuff
function apir(){
    sudo -- bash -c "apt update ; apt clean  ; apt install --reinstall -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew $@"
}

function eet_conf_unpack_all_files(){
    find . -mindepth 1 -maxdepth 1 -type f -iname '*'.cfg -exec eet -d {} config {}.src \; ;
}

# this is useful for reload ZSH conf
# alias XX="source $HOME/.zshrc"
alias XX="exec zsh"

# make VIM to work with Ctrl + S for save without freezing the terminal
# No ttyctl, so we need to save and then restore terminal settings
vim() {
    # osx users, use stty -g
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}

