# All generic configuration goes in this file - to expose common configuration
# to both bash and zsh. One could break out the environment into a .profile for
# sh compatibility if desired.

################################################################################
# System Local
################################################################################

# discovery
if [[ $(uname) == "Linux" ]] && [[ $DESKTOP_SESSION == "pop" ]]; then
  export OS="pop"
else
  export OS="mac"
fi

# load un-tracked (secret) shell config from the local machine
if [[ -f $HOME/.secretrc ]]; then
  source $HOME/.secretrc
fi

################################################################################
# Tmux Init
################################################################################

# start tmux or attach
[[ -z $TMUX ]] && tmux new-session -A -s main


################################################################################
# Environment
################################################################################

export EDITOR=nvim
export TERM="screen-256color"

# ---------- optional ----------

# export PYTHONDONTWRITEBYTECODE=1

# ----------------------------------- docker -----------------------------------

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# ------------------------------------ paths -----------------------------------

export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin:$HOME/.cargo/bin:$HOME/Library/Python/3.7/bin/

# ------------------------------------- gpg ------------------------------------

# gpg initialization
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# pop os only
if [[ $OS == "pop" ]] ; then
  gpg-connect-agent updatestartuptty /bye
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

# ------------------------------------- ssh ------------------------------------

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add ~/.ssh/id_rsa ~/.ssh/*pem
fi


################################################################################
# Aliases
################################################################################

# override default things with better alternatives
alias ls="exa -l --group-directories-first"
alias vim="nvim"
alias ps="procs"
alias find="fd"

# custom aliases
alias ll="exa -al --group-directories-first"
alias tf="terraform"
alias dc="docker-compose"
alias d="docker"
alias du="dust"
alias kk="kubectl"
alias pg="pgrep -fl"
alias gci="git commit"
alias bl="bazelisk"

# llt will "long list tree" wrapping the exa command, provide depth and/or path
function llt {
  if [[ -z $1 ]]; then
    exa -l --group-directories-first -T -L3
  elif [[ -z $2 && $1 == *[[:digit:]]* ]]; then
    exa -l --group-directories-first -T -L$1
  elif [[ -z $2 ]]; then
    exa -l --group-directories-first -T $1
  elif [[ $1 == *[[:digit:]]* ]]; then
    exa -l --group-directories-first -T -L$1 $2
  else
    exa -l --group-directories-first -T -L$2 $1
  fi
}

# disable globbing for some commands to avoid escaping them
alias http="noglob http"


################################################################################
# Setup
################################################################################

function confirm {
  read -p "Run '$*'? [yN]" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    $*
  fi
}

# install all dependencies and bootstrap
function install-deps {
  # check prerequisites
  if [[ $OS == "mac" ]]; then
    which brew
    if [ $? -eq 0 ]; then
      echo "Install homebrew before proceeding" && return
    fi
  fi

  # install oh-my-zsh
  confirm curl -fsSL \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
    \| sh

  # install rust and tooling
  echo "Installing rust dependencies..."
  confirm curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh
  confirm cargo install bandwhich bat dust exa fd-find procs sd

  # install alacritty
  echo "Installing default tools..."
  if [[ $OS == "pop" ]]; then
    confirm sudo apt-get install httpie jq nmap nodejs npm tig tmux zeal
  elif [[ $OS == "mac" ]]; then
    confirm brew install httpie jq nmap tig tmux
    confirm brew cask install alacritty
  fi

  # install golang and tooling
  echo "Installing golang..."
  if [[ $OS == "pop" ]]; then
    confirm sudo apt-get install golang graphviz
  elif [[ $OS == "mac" ]]; then
    confirm brew install golang
  fi
  echo "Installing golang tools..."
  confirm go get -u github.com/containous/yaegi/cmd/yaegi

  # install neovim
  echo "Installing neovim..."
  if [[ $OS == "pop" ]]; then
    confirm sudo apt-get install neovim python3-neovim
  elif [[ $OS == "mac" ]]; then
    confirm brew install neovim
  fi

  # install neovim plugins
  echo "Installing neovim plugins..."
  confirm nvim +PlugUpgrade +PlugClean +PlugInstall +PlugUpdate +qall

  # install CoC extensions
  echo "Installing CoC extensions..."
  vim +CocInstall coc-yaml coc-vimlsp coc-tsserver coc-rls coc-python coc-pyright \
    coc-json coc-html coc-phpls +qall

  echo "Installing aws-iam-authenticator"
  if [[ $OS == "mac" ]]; then
    confirm brew install aws-iam-authenticator
  fi

  echo "Installing bettercap..."
  confirm go get github.com/bettercap/bettercap
  if [[ $OS == "pop" ]]; then
    confirm sudo setcap cap_net_raw,cap_net_admin=eip $(which bettercap)
  fi
  confirm sudo $(which bettercap) -eval "caplets.update; ui.update; q"
  if [[ $OS == "pop" ]]; then
    confirm sudo sed -ie 's/80$/1313/g' \
      /usr/local/share/bettercap/caplets/http-ui.cap
  fi

  echo "Installing bazelisk..."
  confirm go get github.com/bazelbuild/bazelisk
}


################################################################################
# Functions (Common)
################################################################################

# cd to the current repo root
alias gr='cd $(git rev-parse --show-cdup)'

# start cadvisor to monitor local container resources
function cadvisor {
  docker run \
    --volume=/:/rootfs:ro \
    --volume=/var/run:/var/run:ro \
    --volume=/sys:/sys:ro \
    --volume=/var/lib/docker/:/var/lib/docker:ro \
    --volume=/dev/disk/:/dev/disk:ro \
    --publish=8080:8080 \
    --name=cadvisor \
    --rm \
    google/cadvisor:latest
}

# strip first word from each line, optionally pass delimiter
function first {
  if [[ -z $1 ]]; then
    awk '{print $1}'
  else
    awk -F $1 '{print $1}'
  fi
}

# strip second word from each line
function second {
  awk '{print $2}'
}

# git checkout last branch
function glb {
  git checkout @{-1}
}

# repeat command N times
function re {
  if [[ -z $1 ]]; then
    echo "usage (cd up 3 directories): re 3 cd .."
  else
    times=$1
    shift
    for i in $( seq 1 $times ); do
        eval $@
    done
  fi
}

# today in iso date format
function today {
  date +%Y-%m-%d
}

# setup local socks proxy at localhost:8123 to provided server over SSH
function proxy {
  ssh -D 8123 -C -q -N $1
}


################################################################################
# Functions (Mac Only)
################################################################################

if [[ $(uname) == "Darwin" ]]; then

  # flush the local dns cache
  function flush-dns {
    dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  }

fi


################################################################################
# Bash
################################################################################

# This section contains configuration that should apply to only the bash shell.

if [[ $SHELL =~ bash ]]; then

  # ---------- completions ----------

  source <(kubectl completion bash)
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash

fi
