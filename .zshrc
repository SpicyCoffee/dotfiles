setopt nonomatch

### PATH, ENV ###
export PATH
typeset -U path PATH
#PATH=$(brew --prefix)/bin:$PATH
source ~/.cpad2/profile

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:~/.rd/bin
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS='-iMRX'

### History ###
HISTFILE=~/.zsh_history	 # file saved history
HISTSIZE=10000  # the number of histories on memory
SAVEHIST=10000  # the number of histories
setopt hist_ignore_dups  # not recording duplicate history
setopt share_history     # share histories between other shells
setopt hist_reduce_blanks  # delete blanks when saving hisotries

### Completion ###
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' use-cache true

### Prompt ###
autoload -U colors; colors; zstyle ':completion:*' list-colors "${LS_COLORS}"
setopt prompt_subst

# general user
prompt="%F{cyan}[%n@%D{%m/%d %T}]%f "
prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
rprompt="%{${fg[magenta]}%}[%~]%{${reset_color}%}"
sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# root user
if [ ${UID} -eq 0 ]; then
prompt="%B%U${prompt}%u%b"
  prompt2="%B%U${prompt2}%u%b"
  rprompt="%B%U${rprompt}%u%b"
  sprompt="%B%U${sprompt}%u%b"
fi

PROMPT=$prompt    # set configures to prompt
PROMPT2=$prompt2  # second prompt
RPROMPT=$'`branch-status-check` ${rprompt}'  # right prompt (for git branch name)
SPROMPT=$sprompt  # prompt for spell check

# prompt when ssh login
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;


### display git branch name ###
function branch-status-check {
  local prefix branchname suffix

  # return if in the '.git'
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi

  branchname=`get-branch-name`
  if [[ -z $branchname ]]; then
    return
  fi

  prefix=`get-branch-status`
  suffix='%{'${reset_color}'%}'
  echo ${prefix}"(${branchname})"${suffix}
}

function get-branch-name {
  echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

function get-branch-status {
  local res color
  output=`git status --short 2> /dev/null`
  if [ -z "$output" ]; then
    res=':'  # Clean
    color='%{'${fg[green]}'%}'
  elif [[ $output =~ "[\n]?\?\? " ]]; then
    res='?:' # Untracked
    color='%{'${fg[yellow]}'%}'
  elif [[ $output =~ "[\n]? M " ]]; then
    res='M:' # Modified
    color='%{'${fg[red]}'%}'
  else
    res='A:' # Added to commit
    color='%{'${fg[cyan]}'%}'
  fi
  # echo ${color}${res}'%{'${reset_color}'%}'
  echo ${color}
}


### for zplug ###
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

### Define plugins
  zplug "b4b4r07/enhancd", use:init.sh  # enhance moving on CL
  zplug "zsh-users/zsh-autosuggestions"  # suggest commands
  zplug "zsh-users/zsh-syntax-highlighting", defer:3  # syntax hilight
  zplug "zsh-users/zsh-completions"  # completion of command input
###

# Install them
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load # --verbose


### Color man
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

### Alias ###
alias cl='clear'
alias ls='ls -GF'
alias ll='ls -l'
alias la='ls -la'

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

source ~/.zshrc_local

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/kohei-arai/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
