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
HISTSIZE=101000
SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST
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
With FASD feature you can fastly access to (commonly used) directories or
files by triggering a remembered autocompleting list, if you do something like
'vi ,sh' and press TAB, it will open an autocomplete list of matches including
the 'sh' keyword, there's some examples: $fg[green]
  - use 'j' to interactivey enter in used directories
  - "vim ,rc,lo <TAB>" -> open matches containing 'rc' and then 'lo' keywrods,
    like "vim /etc/rc.local" - use f,WORD to specify that it is a file
  - use d,WORD to specify that it is a directory
  - use WORD,,f <TAB> if you want to trigger it after to type the word

$fg[yellow]
ZSH generic examples
====================
$fg[white]
Zsh by default allows you to have a good amount of features, for example:

  - ls *(.)            # list just regular files
  - ls *(/)            # list just directories
  - ls -ld *(/om[1,3]) # Show three newest directories. "om" orders by
    modification. "[1,3]" works like Python slice.  
  - rm -i *(.L0)       # Remove zero length files, prompt for each file
  - ls *(^m0)          # Files not modified today.
  - emacs **/main.py   # Edit main.py, wherever it is in this directory tree.
  - ls **/*(.x)        # List all executable files in this tree
  - ls *~*.*(.)        # List all files that does not have a dot in filename
  - ls -l */**(Lk+100) # List all files larger than 100kb in this tree
  - ls DATA_[0-9](#c4,7).csv # List DATA_nnnn.csv to DATA_nnnnnnn.csv

$fg[yellow]
Elive Features
==============
$fg[white]
The ZSH setup by Elive includes lots of features, for example:
  - pressing "ctrl + e" and then a dot, will insert the last typed word again
    (useful for similar words/dirs in your commands)
  - run "alias" to know the ton of aliases already set
  - if you ssh to another elive, a tmux session is automatically opened for it
    (try: ssh localhost)
  - type a word and then the up arrow to browse your command history
  - lots of syntax hilighting, even for manpages
  - autocompletions with extreme possibilities, for example, try:
    - kill <TAB>
    - xkill -id <TAB>
    - man find<TAB>  (shows the sections/topics of manpages for each
      possibility)
    - cd ...  becomes  cd ../..  in realtime while you are typing it
    - your prompt working directory (pwd) is shortcuted to an expandable (tab)
      value
      - "vim /et/d/us<TAB>" expands to "vim /etc/default/adduser.conf"
      - "cd /u/lo/b<TAB>" expands to "cd /usr/local/bin"
    - use tab for corrections also, not only complete
  - tmux (screen-like) is automatically opened or reconnected when you login
    from ssh
    - tmuxa / tmuxl are shortcuts to connect or list the sessions
    - read your .tmux.conf file comments to know its amazing features
  - Git: you have aliases and an identifying prompt for git statuses
    http://4.bp.blogspot.com/-VEdW0qxzPCI/UTUpYhFutFI/AAAAAAAAJJc/00OAaDNZvIQ/s1600/prezto-git-icons-key.png
  - your new terminals always open in your last-worked-dir by default
  - with "Ctrl + g" you can switch from per-directory-based history and normal
    mode
  - run the command "history-stat" to know your top-10 most used commands
    (then create aliases/functions/scripts to improve in the commands that takes
    you more time!)
    - example "alias | grep git" to know which aliases you have available for
      common git commands
  - if you work in a common dir called git, type "cd d,git<TAB>" and you will
    be expanded to it
  - with "Ctrl + w" you remove the last word, this feature is extremely useful
  - with "Ctrl + -" you have an "undo" feature in your shell, even if you
    removed something or your expansion become very big or your contents
    changed, OMG BONUS!


EOF

if ((TERMINOLOGY)) ; then
    cat << EOF
$fg[yellow]
Terminology!
============
$fg[white]
You are using the Enlightened Terminal, please try these hotkeys if you didn't
already know about them!
 TABS
 ----
  - Shift + Ctrl + T:           Opens a new Tab
  - Ctrl + PagUp/Down:          Switches from the opened Tabs
  - Ctrl + Home:		Selector of Tabs with mouse
  - Ctrl + (Number):		Go to the tab "number" directly
 Splits
 ------
 Create new shell sessions in a splitted window that you can resize with mouse!
  - Ctrl + Shift + PagUp:	Splits horizontally
  - Ctrl + Shift + PagDown:	Splits vertically
 Copy / Paste
 ------------
  - Ctrl + Shift + c: Copy a selected text
  - Ctrl + Shift + v: Paste a copied text
    - when you simply hilight something, becomes also copied in primary buffer
  - Alt + Enter: Paste a hilighted selection
    - using "shift [+ctrl] + insert" you can also paste the primary/clipboard
 Other
 -----
  - Alt + Home: Enter commands that controls your terminology (man terminology)
  - Ctrl + mouse-wheel: resize font

EOF
fi

if [[ "$TERM" = "screen-256color" ]] ; then
    cat << EOF
$fg[yellow]
SSH / TMUX
==========
$fg[white]
Tmux is a terminal multiplexer similar to 'screen' with a lot of features, like
being able to share the same terminal or open multiple instances/tabs, splits,
and specially to be able to disconnect from the remote computer with the
session opened
  - Shift + Down:  Create a new tab
  - Ctrl + Left/Rigth:  Switch between tabs
  -
  - Ctrl + a:  is the trigger for the tmux actions (originally was 'b'), like:
    - Ctrl-a c Create new window
    - Ctrl-a d Detach current client, to keep the session opened
    - Ctrl-a l Move to previously selected window
    - Ctrl-a n Move to the next window
    - Ctrl-a p Move to the previous window
    - Ctrl-a & Kill the current window
    - Ctrl-a , Rename the current window
    - Ctrl-a % Split the current window into two panes
    - Ctrl-a o Switch to the next pane
    - Ctrl-a ? List all keybindings
    -
    - Ctrl-a | Split window horizontally
    - Ctrl-a - Split window vertically
    - Ctrl-a q Show pane numbers (used to switch between panes)
    - Ctrl-a t Split to a small window in the bottom, useful for fast needs!
    -
    - read your $HOME/.tmux.conf file for more info in the comments

EOF
fi

# END
cat << EOF
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


