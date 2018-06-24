#source bash rc so that they both load
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

### colorize
export GREP_OPTIONS='--color=auto'
export CLICOLOR=1

### aliases
# grep history
alias histg='history | grep '
# set home dir as working tree of dot files
alias dotfilesgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'
# git
alias g='git'

#colour ls output without error
ls --color=al > /dev/null 2>&1 && alias ls='ls -F --color=al' || alias ls='ls -G'

### bash prompt
git_branch () { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'; }

LOCATION='\033[01;34m\][\W]\\'
BRANCH=' \033[00;33m\]$(git_branch)\[\033[00m\]\n'

PS1="$LOCATION$ $BRANCH"
PS2='\[\033[01;36m\]>'

### bash history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

### bash history searching
# http://thirtysixthspan.com/posts/grep-history-for
# ghf - [G]rep [H]istory [F]or top ten commands and execute one
# usage:
#  Most frequent command in recent history
#   ghf
#  Most frequent instances of {command} in all history
#   ghf {command}
#  Execute {command-number} after a call to ghf
#   !! {command-number}
function latest-history { history | tail -n 50 ; }
function grepped-history { history | grep "$1" ; }
function chop-first-column { awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' ; }
function add-line-numbers { awk '{print NR " " $0}' ; }
function top-ten { sort | uniq -c | sort -r | head -n 10 ; }
function unique-history { chop-first-column | top-ten | chop-first-column | add-line-numbers ; }
function ghf {
  if [ $# -eq 0 ]; then latest-history | unique-history; fi
  if [ $# -eq 1 ]; then grepped-history "$1" | unique-history; fi
  if [ $# -eq 2 ]; then
    `grepped-history "$1" | unique-history | grep ^$2 | chop-first-column`;
  fi
}

