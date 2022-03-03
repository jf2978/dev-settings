# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# uncomment for debugging prompt/zsh slowness
# zmodload zsh/zprof

# helper func for testing out the speed of the shell in case things get slow
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# replace that ugly-green WSL directory highlighting
LS_COLORS="ow=01;36;40" && export LS_COLORS

# start ssh
SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent (for seamlessly authenticating w/ Github)
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# git config stuff

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-nvm
)

# do zsh shell things
source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases

# uncomment lines below if need for working with direnv
# todo: find a cleaner way to conditionally apply these things (without slowing down the whole prompt)

# PS1='$(show_virtual_env) '$PS1
# setopt PROMPT_SUBST

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}

# use direnv to unload env vars based on which directory I'm in
# eval "$(direnv hook zsh)"

# uncomment for debugging prompt/zsh slowness
# zprof
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# golang things
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$PWD/bin
export PATH=$GOPATH/bin:$GOROOT/bin:$GOBIN:$PATH
