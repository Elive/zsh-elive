# Some apt shortcuts for your shell
alias apsrc="is_alias=1 apt source"
alias apse="is_alias=1 apt search"
alias apsh="is_alias=1 apt show"
alias appo="is_alias=1 apt policy"
alias apu="is_alias=1 sudo apt update"
alias apug="is_alias=1 ; if sudo apt update ; then sudo apt -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confnew\" dist-upgrade ; fi"
alias apc="is_alias=1 ; sudo -H bash -c 'apt --purge autoremove ; apt autoclean ; apt clean ; rm -rf /var/lib/apt/lists/* ; rm -rf /var/cache/apt/archives/*'"
alias api="is_alias=1 ; sudo apt install"
alias apui="is_alias=1 ; sudo apt update ; sync ; sudo apt install"
alias apif="is_alias=1 ; sudo apt -f install"
alias apr="is_alias=1 ; sudo apt remove"

# same for dpkg
alias dpi="sudo dpkg -i"
alias dpl="dpkg -l"
alias dpL="dpkg -L"

# other apt* related stuff
alias apfs="is_alias=1 ; apt-file search"

# hacks and improvements
alias less="less -gR"

# startx wont run correctly if you "su" to another user because teh Xauthority is inherited, but we want to keep it otherwise by login to other user we cannot launch X applications in our destkop too
startx(){
    unset XAUTHORITY
    command startx "$@"
}

# make VIM to work with Ctrl + S for save without freezing the terminal
# No ttyctl, so we need to save and then restore terminal settings
vim()
{
    # osx users, use stty -g
    local STTYOPTS="$(stty --save)"
    stty stop '' -ixoff
    command vim "$@"
    stty "$STTYOPTS"
}
