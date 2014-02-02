# warning: this can be unsecure?
alias -g ...=../..
alias -g ....=../../..
alias -g .....=../../../..
alias -g ......=../../../../..
alias -g .......=../../../../../..
alias -g ........=../../../../../../..

# apt* related stuff
function apir(){
    sudo -- sh -c "apt-get update ; rm -f /var/cache/apt/archives/${1}_*.deb ; apt-get install --reinstall $@"
}

# this is useful for reload ZSH conf
alias XX="source $HOME/.zshrc"


