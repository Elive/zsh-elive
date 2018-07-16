# Some apt shortcuts for your shell
alias apsrc="apt-get source"
alias apse="apt-cache search"
alias apsh="apt-cache show"
alias appo="apt-cache policy"
alias apu="sudo apt-get update"
#alias apug="sudo apt-get update ; sudo apt-get -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confnew\" dist-upgrade"
if grep -qs "^first-user: ${USER}$" /etc/elive-version ; then
    alias api="apt-get install"
    alias apui="apt-get update ; sync ; apt-get install"
    alias apif="apt-get -f install"
    alias apr="apt-get remove"
    alias dpi="dpkg -i"
else
    alias api="sudo apt-get install"
    alias apui="sudo apt-get update ; sync ; apt-get install"
    alias apif="sudo apt-get -f install"
    alias apr="sudo apt-get remove"
    alias dpi="sudo dpkg -i"
fi

alias dpl="dpkg -l"
alias dpL="dpkg -L"

# other apt* related stuff
alias apfs="apt-file search"

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

apug(){
    if grep -qs "^first-user: ${USER}$" /etc/elive-version ; then
        if apt-get update ; then
            apt-get -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confnew" dist-upgrade
        fi
    else
        if sudo apt-get update ; then
            sudo apt-get -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confnew" dist-upgrade
        fi
    fi
}
