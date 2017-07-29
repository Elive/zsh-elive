# Some apt shortcuts for your shell
alias apsrc="apt-get source"
alias apse="apt-cache search"
alias apsh="apt-cache show"
alias appo="apt-cache policy"
alias apu="sudo apt-get update"
alias apug="sudo apt-get update ; sync ; sudo apt-get dist-upgrade"
alias api="sudo apt-get install"
alias apui="sudo apt-get update ; sync ; sudo apt-get install"
alias apif="sudo apt-get -f install"
alias apr="sudo apt-get remove"

# same for dpkg
alias dpi="sudo dpkg -i"
alias dpl="dpkg -l"
alias dpL="dpkg -L"

# other apt* related stuff
alias apfs="apt-file search"

# hacks and improvements
alias less="less -gR"

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
