################# Start Elive default confs ###################
#
# To source the confs from /etc allows you to obtain fixes and improvments to your shell by upgrading the related packages, however you can copy the file locally to your home and source it instead, but we suggest to keep the things as how they are set.
#
# comment it if you want to use your own copy of prezto (not recommended, since we forked/modified it for a better elive experience)
ZDOTDIR="/etc/zsh"
#
# get the optimal default elive confs
source /etc/zsh/zshrc.elive.zsh
unset ZDOTDIR


echo "                     $fg[green]Type 'help' to know the ton of Elive features available...$reset_color"

# do we are in tmux?
if [[ "$TERM" = "screen-256color" ]] ; then
    echo "                     $fg[green]             See the special features when working in ssh!$reset_color"
fi

#
################# End Elive default confs ###################

# Customize to your needs here...




