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
if [[ -r /usr/lib/elive-tools/functions ]] ; then
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
        #echo -e "Do you want GIT plugin for your shell? This plugin makes your shell to be SLOW, only activate it if you are a very git-active user, you can also use only the aliases, you can deactivate it later by removing the entry from the ~/.zpreztorc file."

        #if el_confirm "\nActivate git plugin ?" ; then
            # enable the plugin if is not yet enabled
            if ! grep -qs "'git' \\\\" "$HOME/.zpreztorc" ; then
                sed -i "s|'syntax-highlighting.*$|'git' \\\\\n  'syntax-highlighting' \\\|g" "$HOME/.zpreztorc"
                # trying to source the zshrc seems like to throw errors
                #echo -e "Git plugin for your shell activated, run the command 'zsh' to start a new updated shell"
                echo -e "Activated GIT plugin for your shell. You can disable it from ~/.zpreztorc"
                if [[ -n "$el_c_blink" ]] ; then
                    echo -e "You must ${el_c_blink}re-login${el_c_n} in your shell to use it."
                else
                    echo -e "You must re-login in your shell to use it."
                fi
            fi
        #fi

        # disable this function checker
        sed -i 's|^precmd_functions+=(git_plugin_enable_when_needed)|#precmd_functions+=(git_plugin_enable_when_needed)|g' "$HOME/.zshrc"

        # remove this function checker from actual shell / session
        r=$precmd_functions[(I)git_plugin_enable_when_needed]
        precmd_functions[r]=()

    fi
}

# very useful realtime helper for git {{{
# TO DISABLE: comment or remove entirely this function
# But note that being annoying is a good thing, it forces you to use 
# the alternatives, which is shorter to type, read and use them when appear
function git(){
    # run the real git command first
    command git "$@"

    if ! ((is_alias)) && [[ -n "$1" ]] && alias | grep git | grep -qs -- "$1" ; then
        echo -e "$fg[green] -- Aliases suggested --$reset_color" 1>&2
        alias | grep git | sed -e 's|is_alias=1 ||g' | GREP_COLOR="36" grep -- "$1" 1>&2
        echo -e "$fg[green] -- You can disable this helper in your .zshrc --$reset_color" 1>&2
    fi
}

# Extra git Alias example, write your own:
#gfr='is_alias=1 git pull --rebase'

# }}}


# - zprezto git plugin }}}

# list of functions to run at each returned shell
typeset -a precmd_functions
# if you have a dir called .git, it will run that function, until you confirm, then will be disabled
precmd_functions+=(git_plugin_enable_when_needed)



# help
echo "                     $fg[green]Type 'help' to know the ton of Elive features available...$reset_color"

# do we are in tmux?
if [[ "$TERM" = "screen-256color" ]] || [[ "$TERM" = "tmux-256color" ]] ; then
    echo "                     $fg[green]             See the special features when working in ssh!$reset_color"
fi

#
################# End Elive default confs ###################

# Customize to your needs here...







# vim: set foldmethod=marker :
