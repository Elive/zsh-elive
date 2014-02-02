# don't show input while loading
stty -echo

#
# FRAMEWORK BASE
#
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# - for details of each feature read /etc/zsh/.zprezto/**/README*

# OVERRIDE framework defaults:
#
# history
HISTSIZE=1000000
SAVEHIST=1000000
#
# completion
#
# ignore completion for specific files
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*?.swp'
zstyle ':completion:*:*:cd:*' ignored-patterns '(*/|)(CVS|SCCS)'

# do not include repeated matches for specific commands, like rm, we don't want to remove a file twice so it will skip to the next match, like: rm two t<tab> => three
zstyle ':completion::*:(rm|trash|rmdir):*' ignore-line true
# similar: do not complete own dir when cd ../<TAB>
zstyle ':completion:*' ignore-parents parent pwd

# propose a better history search way:
__correct_ctrl_r_to_better_history() {
    echo "Instead, type a keyword and press the Up arrow key! try:"
}
zle -N __correct_ctrl_r_to_better_history
bindkey "^r" __correct_ctrl_r_to_better_history





#
# ALIAS
#

# source useful aliases
#    generic ones
if [[ -s "/etc/zsh/.aliases.sh" ]] ; then
    source "/etc/zsh/.aliases.sh"
fi
#    zsh ones
if [[ -s "/etc/zsh/.aliases.zsh" ]] ; then
    source "/etc/zsh/.aliases.zsh"
fi


#
# FUNCTIONS
#
# set colors, be able to use them in prompts
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"


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


#
# OTHER FEATURES
#

# "ctrl-e ." to insert last typed word again
__insert-last-typed-word() { zle insert-last-word -- 0 -1 };
zle -N __insert-last-typed-word;
bindkey "^e." __insert-last-typed-word

# bash auto completions too
autoload bashcompinit
bashcompinit
if [[ -d "${HOME}/.bash_completion.d" ]] ; then
    source "${HOME}/".bash_completion.d/* 2>/dev/null
fi



#
# CONFIGURATIONS
#

# much better "set -x" (debug mode) output
# header:30:case> some code
PS4="${PR_GREY}%N${PR_NO_COLOR}:${PR_GREY}%i${PR_NO_COLOR}:${PR_GREY}%_>${PR_NO_COLOR} "

# notify me of bg jobs exiting immediately - not at next prompt
setopt NOTIFY

# do not kill backgrounded jobs when exiting the shell
setopt NO_CHECK_JOBS
setopt NO_HUP

# do not remove the slashes (dangerous for rsync)
setopt noautoremoveslash

# ask for correction when the command given doesn't exist
setopt CORRECT

# * shouldn't match dotfiles. ever.
setopt noglobdots




#
# END
#

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath PATH



#
# Examples of nice confs (which are probably already set)
#

# if we source bash codes, this makes the * to be compatible, instead of need to use use \*
#setopt nonomatch

# use ^w to match also addresses like /usr/share/foo, not to consider it a single word
#WORDCHARS=${WORDCHARS/\//}

# This was my default completer mode, let's see if we need to switch to this one over the time
#zstyle ':completion:*' completer _expand _complete _approximate
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'




# reenable input
stty echo


# help
echo "                     $fg[green]Type 'help' to know the ton of Elive features available...$reset_color"




