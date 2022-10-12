### Global
#export GOPATH=~/gosrc
#mkdir -p $GOPATH
if [ "$PLATFORM" = 'Darwin' ]; then
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  export PATH=$HOME/.gem/ruby/2.6.0/bin:$PATH
  export PATH="/usr/local/opt/python@3.8/bin:$PATH"
  export EDITOR=nvim
  export GEDITOR=mvim
  export PGDATA='/Volumes/Dai_work/postgresData'
  PATH=/usr/texbin:$PATH
else
  export PATH=~/bin:$PATH
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
  export EDITOR=vim
  export GEDITOR="vim -g"
fi
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### OS X
export COPYFILE_DISABLE=true

# Aliases
# --------------------------------------------------------------------

alias mvim='open -a MacVim'
alias gvim=$GEDITOR
alias vi=$EDITOR
alias vim=$EDITOR
alias ll='ls -l'
alias la='ls -a'
alias lh="ls -a | grep '^\.'"
alias nps='ps -o user,pid,pcpu,pmem,stat,cputime=_CPU_Time_,etime=Elapsed_Time,start=Started,command=CMD | grep -v user'
alias grep='grep --color=auto'
alias which='type -p'
alias startrecord='script -F $HOME/bashRecord/$(date +"%d-%b-%y_%H-%M-%S")_shell.log bash -l'
# alias cmake='/Applications/CMake.app/Contents/bin/cmake'

lt() {
    ls -lt "$@" | head
}


lll() {
    ls -l "$@" | less
}

# On machines with slurm
if [ -x "$(command -v sinfo)" ]; then 
  alias sidle='sinfo | grep idle'
  alias sq='squeue -u $(whoami)'
  alias cdw='cd $WORK'
  alias si='sinfo -o "%.11N %.11T %.14C %.5O %.7m" --Node | uniq'

  cpuon() {
      squeue -o "%N" | sort | uniq | grep "$1" | \
          xargs -I{} sh -c \
          "echo {}; squeue -w {} -o '%i' | gawk 'NR>1 {print \$1}' | xargs -n 1 -I 'ARGS' scontrol show job ARGS | grep -i NumCPUS "
                # squeue -w "$1" | gawk '{print $1 $2}' | xargs -n 1 -I{} scontrol show job {} | grep -i NumCPUs
            }
fi

### Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

# Prompt
# --------------------------------------------------------------------
PS1="\h:\W\$ "
