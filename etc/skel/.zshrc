################# Start Elive default confs ###################
# Disable Talked Voices in your computer?
# note: check also your .zprofile file
#NOVOICE=1
#
# To source the confs from /etc allows you to obtain fixes and improvments to your shell by upgrading the related packages, however you can copy the file locally to your home and source it instead, but we suggest to keep the things as how they are set.
#
# comment it if you want to use your own copy of prezto (not recommended, since we forked/modified it for a better elive experience)
ZDOTDIR="/etc/zsh"
#
# get the optimal default elive confs
source /etc/zsh/zshrc.elive.zsh
unset ZDOTDIR

# get elive-tools features {{{
if [[ -x /usr/lib/elive-tools/functions ]] ; then
    source /usr/lib/elive-tools/functions

    # we really want to setup our shell environment
    # for example having access to the DISPLAY variable from ssh or others
    el_make_environment
fi
# Elive functions loaded from here }}}

# zprezto git plugin {{{
# is disabled by default because is slow, enable if needed in some future
git_plugin_enable_when_needed() {
    local r
    if [[ -d ".git" ]] ; then
        echo -e "Git directory found here, Elive includes a nice 'git' plugin for your shell, it contains features like showing the git status everytime in your prompt, or a ton of git aliases.\n\nThe only problem is that it makes your shell slower when the new prompt is generated (when the shell returns), if you enable it you can disactivate the plugin later by just edit the .zpreztorc file in your home directory and remove the git line from the list of plugins to load."

        if el_confirm "\nDo you want to activate it ?" ; then
            # enable the plugin if is not yet enabled
            if ! grep -qs "'git' \\\\" "$HOME/.zpreztorc" ; then
                sed -i "s|'syntax-highlighting.*$|'git' \\\\\n  'syntax-highlighting' \\\|g" "$HOME/.zpreztorc"
                echo -e "Git plugin for your shell activated, run the command 'zsh' to start a new updated shell"
            fi
        fi

        # disable this function checker
        sed -i 's|^precmd_functions+=(git_plugin_enable_when_needed)|#precmd_functions+=(git_plugin_enable_when_needed)|g' "$HOME/.zshrc"

        # remove this function checker from actual shell / session
        r=$precmd_functions[(I)git_plugin_enable_when_needed]
        precmd_functions[r]=()
    fi
}

# extremely useful realtime helper for git {{{
# remove the entire function block if you found it annoying
# BUT: if you found it annoying it is a good signal, it forces you to
# lose one second reading the alternative/alias, if there's not one for
# your most-used git command, just add your own on this file
function git(){
    if [[ -n "$2" ]] && alias | grep git | grep -qs "${1}.*${2}" ; then
        echo -e "$fg[green]Aliases suggested:$reset_color"
        alias | grep git | grep "${1}.*${2}"
        echo -e "$fg[gray]Note: you can remove this message editing your $HOME/.zshrc$reset_color"
        echo -e "$fg[green]------------------$reset_color"
    else if [[ -n "$1" ]] && alias | grep git | grep -qs "$1" ; then

        echo -e "$fg[green]Aliases suggested:$reset_color"
        alias | grep git | grep "$1"
        echo -e "$fg[gray]Note: you can remove this message editing your $HOME/.zshrc$reset_color"
        echo -e "$fg[green]------------------$reset_color"
    fi
fi
# run it for real now
command git "$@"
}

# }}}


# - zprezto git plugin }}}

# list of functions to run at each returned shell
typeset -a precmd_functions
# if you have a dir called .git, it will run that function, until you confirm, then will be disabled
precmd_functions+=(git_plugin_enable_when_needed)



# help
echo "                     $fg[green]Type 'help' to know the ton of Elive features available...$reset_color"

# do we are in tmux?
if [[ "$TERM" = "screen-256color" ]] ; then
    echo "                     $fg[green]             See the special features when working in ssh!$reset_color"
fi

#
################# End Elive default confs ###################

# Customize to your needs here...







# vim: set foldmethod=marker :
