# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM="xterm-256color"

# Source antidote.
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Initialize antidote's dynamic mode, which changes `antidote bundle`
# from static mode.
source <(antidote init)

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antidote bundle ohmyzsh/ohmyzsh
antidote bundle ohmyzsh/ohmyzsh path:plugins/battery
antidote bundle ohmyzsh/ohmyzsh path:plugins/colored-man-pages
antidote bundle ohmyzsh/ohmyzsh path:plugins/colorize
antidote bundle ohmyzsh/ohmyzsh path:plugins/docker
antidote bundle ohmyzsh/ohmyzsh path:plugins/encode64
antidote bundle ohmyzsh/ohmyzsh path:plugins/fzf
antidote bundle ohmyzsh/ohmyzsh path:plugins/gem
antidote bundle ohmyzsh/ohmyzsh path:plugins/git
antidote bundle ohmyzsh/ohmyzsh path:plugins/git-extras
antidote bundle ohmyzsh/ohmyzsh path:plugins/kubectl
antidote bundle ohmyzsh/ohmyzsh path:plugins/kubectx
antidote bundle ohmyzsh/ohmyzsh path:plugins/kube-ps1
antidote bundle ohmyzsh/ohmyzsh path:plugins/node
antidote bundle ohmyzsh/ohmyzsh path:plugins/npm
antidote bundle ohmyzsh/ohmyzsh path:plugins/pip
antidote bundle ohmyzsh/ohmyzsh path:plugins/pipenv
antidote bundle ohmyzsh/ohmyzsh path:plugins/pylint
antidote bundle ohmyzsh/ohmyzsh path:plugins/python
antidote bundle ohmyzsh/ohmyzsh path:plugins/ruby
antidote bundle ohmyzsh/ohmyzsh path:plugins/sudo
antidote bundle ohmyzsh/ohmyzsh path:plugins/vagrant
antidote bundle ohmyzsh/ohmyzsh path:plugins/yarn

antidote bundle ahmetb/kubectx path:completion kind:fpath

# Syntax highlighting and autosuggestions
antidote bundle zsh-users/zsh-syntax-highlighting
antidote bundle zsh-users/zsh-autosuggestions

antidote bundle belak/zsh-utils path:completion

# pure theme
# https://github.com/sindresorhus/pure
#antidote bundle mafredri/zsh-async
#antidote bundle sindresorhus/pure

# powerlevel10k theme
# https://github.com/romkatv/powerlevel10k
antidote bundle romkatv/powerlevel10k

# bullet train theme
# https://github.com/caiogondim/bullet-train.zsh
#antidote bundle caiogondim/bullet-train.zsh

##### START Fix for ssh-agent {
# Ref: http://mah.everybody.org/docs/ssh

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
     source "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          start_agent;
     }
else
     start_agent;
fi
##### } END Fix for ssh-agent

# Start Docker daemon automatically when logging in if not running.
RUNNING=`ps aux | grep dockerd | grep -v grep`
if [ -z "$RUNNING" ]; then
    sudo dockerd > /dev/null 2>&1 &
    disown
fi

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# make sure pipenv creates virtualenv dir in current dir under .venv
export PIPENV_VENV_IN_PROJECT=1

# make vagrant use virtualbox as the default provider
export VAGRANT_DEFAULT_PROVIDER='virtualbox'

# extra aliases, functions and variables can be defined in these files
[ -f ~/.shell_aliases  ] && source ~/.shell_aliases
[ -f ~/.shell_functions  ] && source ~/.shell_functions
[ -f ~/.shell_variables ] && source ~/.shell_variables

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
