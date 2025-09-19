# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # if you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
VOLTA_HOME="$HOME/.volta"

# download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# load completions
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C


zinit cdreplay -q

# to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# keybindings
bindkey -e
# bindkey '^y' autosuggest-accept # doubt this works, but will keep it here in case I want to figure out how to make it happen
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^I' complete-word

# history
HISTSIZE=3000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
setopt GLOB_DOTS # include dotfiles

# aliases
alias ls='ls --color'
alias grep='rg'
alias rm='trash-put'
alias py='python3'

alias gitssh='git config core.sshCommand "ssh -i ~/.ssh/github -F /dev/null"'

alias vim='nvim'
alias zshh='source ~/.zshrc'
alias zshedit='nvim ~/.zshrc'
alias sshedit='nvim ~/.ssh'

alias cdgit='mkdir -p ~/git && cd ~/git'
alias cdssh='mkdir -p ~/.ssh && cd ~/.ssh'

alias cddot='cd ~/.dotfiles'

# shell integrations
eval "$(fzf --zsh)"


export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools:$VOLTA_HOME/bin
export MASON=$HOME/.local/share/nvim/mason

zinit light Aloxaf/fzf-tab
