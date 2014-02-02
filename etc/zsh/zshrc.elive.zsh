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


# not convinced with "sharedhistory", it don't allow you to replay easly commands in the same terminals
setopt nosharehistory



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
# show help to the user
function help(){
    #if [[ -n "$1" ]] then
	#command help
    #else
	#/etc/alternatives/x-www-browser "http://www.elivecd.org/?s=zsh"
    #fi
    # Let's show him some tips for now:
cat << EOF
$fg[blue]








                _____ _ _                     _________  _   _
               | ____| (_)_   _____     _    |__  / ___|| | | |
               |  _| | | \ \ / / _ \  _| |_    / /\___ \| |_| |
               | |___| | |\ V /  __/ |_   _|  / /_ ___) |  _  |
               |_____|_|_| \_/ \___|   |_|   /____|____/|_| |_|


$fg[yellow]
More about Zsh
==============
$fg[white]
  - More Info & Best Tips:
  - Best Tips:     http://www.rayninfo.co.uk/tips/zshtips.html
  - Zsh Lovers:    http://grml.org/zsh/zsh-lovers.html

$fg[yellow]
Commonly used Directories & Files
=================================
$fg[white]
With FASD feature you can fastly access to (commonly used) directories or files by triggering a remembered autocompleting list, if you do something like 'vi ,sh' and press TAB, it will open an autocomplete list of matches including the 'sh' keyword, there's some examples:
$fg[green]
  - use 'j' to interactivey enter in used directories
  - "vim ,rc,lo <TAB>" -> open matches containing 'rc' and then 'lo' keywrods, like "vim /etc/rc.local"
  - use f,WORD to specify that it is a file
  - use d,WORD to specify that it is a directory
  - use WORD,,f <TAB> if you want to trigger it after to type the word

$fg[yellow]
ZSH generic examples
====================
$fg[white]
Zsh by default allows you to have a good amount of features, for example:

  - ls *(.)            # list just regular files
  - ls *(/)            # list just directories
  - ls -ld *(/om[1,3]) # Show three newest directories. "om" orders by modification. "[1,3]" works like Python slice.
  - rm -i *(.L0)       # Remove zero length files, prompt for each file
  - ls *(^m0)          # Files not modified today.
  - emacs **/main.py   # Edit main.py, wherever it is in this directory tree. ** is great.
  - ls **/*(.x)        # List all executable files in this tree
  - ls *~*.*(.)        # List all files that does not have a dot in the filename
  - ls -l */**(Lk+100) # List all files larger than 100kb in this tree
  - ls DATA_[0-9](#c4,7).csv # List DATA_nnnn.csv to DATA_nnnnnnn.csv

$fg[yellow]
Elive Features
====================
$fg[white]
The ZSH setup by Elive includes lots of features, for example:
  - pressing "ctrl + e" and then a dot, will insert the last typed word again (useful for similar words/dirs in your commands)
  - run "alias" to know the ton of aliases already set
  - if you ssh to another elive, a tmux session is automatically opened for it (try: ssh localhost)
  - type a word and then the up arrow to browse your command history
  - lots of syntax hilighting, even for manpages
  - autocompletions with extreme possibilities, for example, try:
    - kill <TAB>
    - xkill -id <TAB>
    - man find<TAB>  (shows the sections/topics of manpages for each possibility)
    - cd ...  becomes  cd ../..  in realtime while you are typing it
    - your prompt working directory (pwd) is shortcuted to an expandable (tab) value
      - "vim /et/d/us<TAB>" expands to "vim /etc/default/adduser.conf"
      - "cd /u/lo/b<TAB>" expands to "cd /usr/local/bin"
    - use tab for corrections also, not only complete
  - tmux (screen-like) is automatically opened or reconnected when you login from ssh
    - tmuxa / tmuxl are shortcuts to connect or list the sessions
    - read your .tmux.conf file comments to know its amazing features
  - Git: you have aliases and an identifying prompt for git statuses  http://4.bp.blogspot.com/-VEdW0qxzPCI/UTUpYhFutFI/AAAAAAAAJJc/00OAaDNZvIQ/s1600/prezto-git-icons-key.png
  - with "Ctrl + w" you remove the last word, this feature is extremely useful
  - with "Ctrl + -" you have an "undo" feature in your shell, even if you removed something or your expansion become very big or your contents changed, BONUS!
  - your new terminals always open in your last-worked-dir by default
  - with "Ctrl + g" you can switch from per-directory-based history and normal mode
  - run the command "history-stat" to know your top-10 most used commands (then create aliases/functions/scripts to improve in the commands that takes you more time!)
    - "alias | grep git" to know which aliases you have available for common git commands



$fg[green]
             _             _
  ___ _ __  (_) ___  _   _| |
 / _ \ '_ \ | |/ _ \| | | | |
|  __/ | | || | (_) | |_| |_|
 \___|_| |_|/ |\___/ \__, (_)
          |__/       |___/



$fg[cyan]
Press Shift + PagUp to scroll up in your terminal
EOF
}

echo "                     $fg[green]Type 'help' to know the ton of Elive features available...$reset_color"




