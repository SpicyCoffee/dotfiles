### History ###
HISTFILE=~/.zsh_history	 # file saved history
HISTSIZE=10000  # the number of histories on memory
SAVEHIST=10000  # the number of histories
setopt hist_ignore_dups  # not recording duplicate history
setopt share_history     # share histories between other shells
setopt hist_reduce_blanks  # delete blanks when saving hisotries


### Completion ###
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors "${LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


### Prompt ###
autoload -U colors; colors
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
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Define plugins
zplug "b4b4r07/enhancd", use:init.sh  # enhance moving on CL
zplug "zsh-users/zsh-autosuggestions"  # suggest commands
zplug "zsh-users/zsh-syntax-highlighting", nice:10  # syntax hilight
zplug "zsh-users/zsh-completions"  # completion of command input

# Install them
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose


### PATH ###
PATH=/usr/local/bin:$PATH
HOMEBREW_CASK_OPTS="--appdir=/Applications"


### Alias ###
alias cl='clear'
alias be='bundle exec'
