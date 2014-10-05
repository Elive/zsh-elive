# apt* related stuff
function apir(){
    sudo -- sh -c "apt-get update ; rm -f /var/cache/apt/archives/${1}_*.deb ; apt-get install --reinstall $@"
}

function eet_conf_unpack_all_files(){
    find . -mindepth 1 -maxdepth 1 -type f -iname '*'.cfg -exec eet -d {} config {}.src \; ;
}

# this is useful for reload ZSH conf
alias XX="source $HOME/.zshrc"


