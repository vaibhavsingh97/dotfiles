# =============================================================================
# Enable Powerlevel10k instant prompt — must stay at top
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh My Zsh
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
  git
  z
  colored-man-pages
  colorize
  pip
  python
  brew
  macos
  zsh-completions
  zsh-autosuggestions
  history-substring-search
  alias-tips
  fast-syntax-highlighting
  poetry
)

export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "

source $ZSH/oh-my-zsh.sh

# =============================================================================
# PATH
# =============================================================================
export PATH="/opt/homebrew/bin:$PATH"

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# =============================================================================
# Completions — single compinit call (previously called 3x, which slows startup)
# =============================================================================
fpath=(
  ${ASDF_DATA_DIR:-$HOME/.asdf}/completions
  $(brew --prefix)/share/zsh-completions
  $fpath
)
autoload -Uz compinit

# Only regenerate completion cache once per day (speeds up startup)
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform


# =============================================================================
# History
# =============================================================================
export HISTSIZE=50000000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTIGNORE=" *:ls:cd:cd -:pwd:exit:date:* --help:* -h"

# =============================================================================
# FZF — fuzzy finder
# =============================================================================
FZF_INIT_CACHE="$HOME/.cache/fzf-init.zsh"
if [[ ! -f "$FZF_INIT_CACHE" ]] || [[ "$(command -v fzf)" -nt "$FZF_INIT_CACHE" ]]; then
  fzf --zsh > "$FZF_INIT_CACHE" 2>/dev/null
fi
[[ -f "$FZF_INIT_CACHE" ]] && source "$FZF_INIT_CACHE"

export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"

# =============================================================================
# uv shell completions — cached (previously regenerated on every shell start)
# =============================================================================
UV_COMP_CACHE="$HOME/.cache/uv-completion.zsh"
if [[ ! -f "$UV_COMP_CACHE" ]] || [[ "$(command -v uv)" -nt "$UV_COMP_CACHE" ]]; then
  uv generate-shell-completion zsh > "$UV_COMP_CACHE" 2>/dev/null
fi
[[ -f "$UV_COMP_CACHE" ]] && source "$UV_COMP_CACHE"

# =============================================================================
# Google Cloud SDK
# =============================================================================
if [ -f "/usr/local/google-cloud-sdk/path.zsh.inc" ]; then
  source "/usr/local/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "/usr/local/google-cloud-sdk/completion.zsh.inc" ]; then
  source "/usr/local/google-cloud-sdk/completion.zsh.inc"
fi

# =============================================================================
# Atuin — shell history sync
# =============================================================================
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"


# =============================================================================
# Powerlevel10k prompt config
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# Aliases — General
# =============================================================================
alias reload="source ~/.zshrc"
alias fdir='find . -type d -name'
alias ffil='find . -type f -name'

# Better CLI tools (requires: bat, htop, prettyping, ncdu, tldr)
alias cat="bat"
alias top="btop"
alias help='tldr'
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ls="eza"
alias grep="rg"
alias find="fd"
alias cd="z"
alias df="duf"
alias du="dust"
alias ping="gping"
alias curl="curlie"
alias ps="procs"

# Navigation
alias dl="cd ~/Downloads"
alias hm="cd ~"
alias h="history"
alias 1.="cd .."
alias 2.="cd ../.."
alias 3.="cd ../../.."
alias 4.="cd ../../../.."
alias 5.="cd ../../../../.."
alias 6.="cd ../../../../../.."
alias 7.="cd ../../../../../../.."

# Tree shortcuts
alias tree="tree -A"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"

# SSH / Keys
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub && echo '=> Public key copied to pasteboard.'"

# System info
alias displays="system_profiler SPDisplaysDataType"
alias cpu="sysctl -n machdep.cpu.brand_string"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; echo "✌️ DNS flushed"'

# Cleanup
alias cleands="find . -type f -name '*.DS_Store' -ls -delete"
alias update='brew cleanup; brew upgrade; brew update; npm update -g; npm install npm@latest -g'

# fzf
alias preview="fzf --preview 'bat --color \"always\" {}'"
