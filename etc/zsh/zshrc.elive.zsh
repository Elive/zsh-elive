# don't show input while loading
stty -echo

# STARTUP checkers
DIRSTACKFILE="$HOME/.cache/zsh/zdirs"
if [[ ! -e "$DIRSTACKFILE" ]] ; then
    mkdir -p "$HOME/.cache/zsh"
    touch "$DIRSTACKFILE"
fi

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
# This matcher seems to be better than the default one, it gives us less "wrong corrections":
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# ignore completion for specific files
# note: if you enable them, you cannot autocomplete them, and you may want to, in fact (what about rm, huh ?)
#zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*?.swp'
#zstyle ':completion:*:*:cd:*' ignored-patterns '(*/|)(CVS|SCCS)'

# do not include repeated matches for specific commands, like rm, we don't want to remove a file twice so it will skip to the next match, like: rm two t<tab> => three
zstyle ':completion::*:(rm|trash|rmdir):*' ignore-line true
# similar: do not complete own dir when cd ../<TAB> # actually this feature is more annoying than other thing
#zstyle ':completion:*' ignore-parents parent pwd
# complete things like:  cd ..<TAB>
zstyle ':completion:*' special-dirs true

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

# run command line as user root via sudo:
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

#k# prepend the current command with "sudo"
bindkey "^os" sudo-command-line
#bindkey "^[s" sudo-command-line # I like "alt + s", but urxvt don't allow it

if zle -N edit-command-line ; then
    #k# Edit the current line in \kbd{\$EDITOR}
    bindkey '\ee' edit-command-line
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

# dir stack options
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_MINUS
unsetopt AUTO_NAME_DIRS

DIRSTACKSIZE=32

autoload -U is-at-least
# Keep dirstack across logouts
if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    dirstack=( ${(u)dirstack} )
fi

# Make sure there are no duplicates
typeset -U dirstack

# Share dirstack between multiple zsh instances
function chpwd() {
    if is-at-least 4.1; then # dirs -p needs 4.1
        # Get the dirstack from the file and add it to the current dirstack
        dirstack+=( ${(f)"$(< $DIRSTACKFILE)"} )
        dirstack=( ${(u)dirstack} )
        #dirs -pl | sort -u | grep -v "^${HOME}$" >! ${DIRSTACKFILE}
        dirs -pl | grep -v "^${HOME}$" >! ${DIRSTACKFILE}
    fi
}

# go to parent directory in stack with alt + p
function _directories_switcher_up() {
    local line is_firstline_done
    popd

    # show the stack
    echo -e "\n $fg[yellow] -- Directory Stack -- $fg[white]"
    while read -r line
    do
        if ((is_firstline_done)) ; then
            echo "$line"
        else
            echo "$fg[green]${line}$fg[white]"
            is_firstline_done=1
        fi
    done <<< "$( dirs -v | head -9 )"

    # update the prompt
    if [[ "$(zstyle -L ":prezto:module:prompt")" =~ sorin ]] ; then
        prompt_sorin_pwd
    fi
    zle reset-prompt
}
zle -N _directories_switcher_up
bindkey '\ep' '_directories_switcher_up'



# do not warn us about that a file already exist when using echo foo > bar
setopt clobber



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
  - Best Tips:     http://www.rayninfo.co.uk/tips/zshtips.html
  - Zsh Lovers:    http://grml.org/zsh/zsh-lovers.html
  - Globbing Match http://zsh.sourceforge.net/Intro/intro_2.html
  - zsh tips       http://www.rayninfo.co.uk/tips/zshtips.html
  - setopt options http://www.cs.elte.hu/zsh-manual/zsh_16.html
  -
  - run the following commands without arguments to know to what you have
    - setopt:    options of zsh
    - alias:     aliases set
    - bindkey:   the "hotkeys" defined
  - zsh features a powerful editor, check all the options available at:
      http://www.cs.elte.hu/zsh-manual/zsh_14.html

$fg[yellow]
Fast Access to Common Files & Directories
=========================================
$fg[white]
With FASD feature you can fastly access to (commonly used) directories or
files by triggering a remembered autocompleting list, if you do something like
'vi ,sh' and press TAB, it will open an autocomplete list of matches including
the 'sh' keyword, there's some examples:
 fasd
 ----
  - use 'j' to interactivey enter in commonly used directories
  - "vim ,rc,lo<TAB>" -> open matches containing 'rc' and then 'lo' keywrods,
     like "vim /etc/rc.local" - use f,WORD to specify that it is a file
  - use d,KEYWORD to specify that it is a directory
  - use KEYWORD,,f <TAB> if you want to trigger it after to type the word
  - use "cd KEYWORD,,d<TAB>" everytime you want to enter in a common dir
 dir stack
 ---------
  - every shell maintains a history of the dirs stack, you can go back to
    previously worked directories (in their order) by simply pressing its
    number (order) and enter, or "cd -NUM", you can also "cp file ~-<TAB>",
    use "dirs -v" (or the "d" alias shortcut) to see where points each num

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
  - ls (#a1)foobar     # Approximate matching, list fobar, foobra, or foxbar.

To have a list of all those glob qualifiers, use the tab as:  ls ./(TAB

$fg[yellow]
Elive Features
==============
$fg[white]
The ZSH setup by Elive includes lots of features, for example:
  - if you ssh to another elive, a tmux session is automatically opened for it
    (try: ssh localhost)
    - tmuxa / tmuxl are shortcuts to connect or list the sessions
    - read your .tmux.conf file comments to know its amazing features
  - type a word and then the up arrow to browse your command history
  - lots of syntax hilighting, even for manpages
  - autocompletions with extreme possibilities, for example, try:
    - kill <TAB>
    - xkill -id <TAB>
    - man find<TAB>  (shows the sections/topics of manpages for each
      possibility)
    - cd ....  becomes  cd ../../..  in realtime while you are typing it
    - your prompt working directory (pwd) is shortcuted to an expandable (tab)
      value
      - "vim /et/d/us<TAB>" expands to "vim /etc/default/adduser.conf"
      - "cd /u/lo/b<TAB>" expands to "cd /usr/local/bin"
    - use tab for corrections also, not only complete
  - Git: you have aliases and an identifying prompt for git statuses
    - runtime aliases suggestions for common git commands (from ~/.zshrc)
  - run the command "history-stat" to know your top-10 most used commands
    (then create aliases/functions/scripts to improve in the commands that takes
    you more time!)
    - example "alias | grep git" to know which aliases you have available for
      common git commands
  - if you work in a common dir called git, type "cd d,git<TAB>" and you will
  - pressing "ctrl + e" and then a dot, will insert the last typed word again
    (useful for similar words/dirs in your commands)
    be expanded to it
  - press "alt + h" to get the help of the first command (zsh builtins too)
  - with "ctrl + i" similar to tab, expand or complete menu
  - with "Ctrl + w" you remove the last word, this feature is extremely useful
  - with "Ctrl + -" you have an "undo" feature in your shell, even if you
    removed something or your expansion become very big or your contents
    changed, OMG BONUS!
  - with "alt + e" it opens your $EDITOR to edit your actual command
  - with "ctrl + o, s" you prepend the command with sudo, useful when you missed
  - with "alt + p" you go to the previous directory stack (last used dirs)


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
  - Ctrl + Shift + Home:	Selector of Tabs with mouse
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
  - Ctrl + a:  is the trigger for the tmux actions (originally was 'b'), like:
    - Ctrl-a c  Create new window (also Shift + Down)
    - Ctrl-a d  Detach current client, to keep the session opened
    - Ctrl-a l  Move to previously selected window
    - Ctrl-a n  Move to the next window
    - Ctrl-a p  Move to the previous window
    - Ctrl + Left/Rigth:  Switch between tabs
    - Ctrl-a PagUp: Scroll up history, 'q' for finish
    - Ctrl-a &  Kill the current window
    - Ctrl-a ,  Rename the current window
    - Ctrl-a %  Split the current window into two panes
    - Ctrl-a o  Switch to the next pane
    - Ctrl-a ?  List all keybindings
    -
    - Ctrl-a |  Split window horizontally
    - Ctrl-a -  Split window vertically
    - Ctrl-a q  Show pane numbers (used to switch between panes)
    - Ctrl-a H/J/K/L  Resize panes
    - Ctrl-a t  Split to a small window in the bottom, useful for fast needs!
    -
    - If you have a tmux inside another tmux (nested), like when ssh twice,
      you can press 'a' the amount of times the nest is located, for example,
      'Ctrl-a a a c' will create a new window in the third-nested tmux
    - Ctrl-b  Is used like a fast hotkey for the second-nested sub-tmux
    -
    - Much more: see the comments in your $HOME/.tmux.conf file

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



EOF

# show how to scroll up
if [[ "$TERM" = "screen-256color" ]] ; then
    cat << EOF
$fg[cyan]
Press 'Ctrl + a' and then PagUp for scroll up (tmux)
  + and then 'q' for quit the scroll mode
EOF
else
    cat << EOF
$fg[cyan]
Press Shift + PagUp to scroll up in your terminal
EOF
fi

}


