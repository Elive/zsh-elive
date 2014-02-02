# warning: this can be unsecure?
#alias -g ...=../..
#alias -g ....=../../..
#alias -g .....=../../../..
#alias -g ......=../../../../..
#alias -g .......=../../../../../..
#alias -g ........=../../../../../../..
#Alternative, thanks to Fenhl
_rationalise-dot() {
    if [[ $LBUFFER == "cd "* ]] || [[ $LBUFFER =~ "[^ ]*" ]]; then
	if [[ $LBUFFER = *.. ]]; then
	    LBUFFER+=/..
	elif [[ $LBUFFER == "cd." ]]; then
	    LBUFFER="cd .."
	else
	    LBUFFER+=.
	fi
    else
	LBUFFER+=.
    fi
}
zle -N _rationalise-dot
bindkey . _rationalise-dot

# apt* related stuff
function apir(){
    sudo -- sh -c "apt-get update ; rm -f /var/cache/apt/archives/${1}_*.deb ; apt-get install --reinstall $@"
}

# this is useful for reload ZSH conf
alias XX="source $HOME/.zshrc"


