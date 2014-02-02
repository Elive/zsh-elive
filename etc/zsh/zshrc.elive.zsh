# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# source useful aliases
#    generic ones
if [[ -s "/etc/zsh/.aliases.sh" ]] ; then
    source "/etc/zsh/.aliases.sh"
fi
#    zsh ones
if [[ -s "/etc/zsh/.aliases.zsh" ]] ; then
    source "/etc/zsh/.aliases.zsh"
fi


# Dot substitution as you type, much better than the classic ... aliases
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

