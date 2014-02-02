# apt* related stuff
function apir(){
    sudo -- sh -c "apt-get update ; rm -f /var/cache/apt/archives/${1}_*.deb ; apt-get install --reinstall $@"
}

# this is useful for reload ZSH conf
alias XX="source $HOME/.zshrc"

# show help to the user
function help(){
    if [[ -n "$1" ]] then
	command help
    else
	/etc/alternatives/x-www-browser "http://www.elivecd.org/?s=zsh"
    fi
}



