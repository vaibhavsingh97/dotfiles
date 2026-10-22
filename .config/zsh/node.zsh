# ==========================================
# ASDF - Runtime Version Manager
# ==========================================

export ASDF_DATA_DIR="$HOME/.asdf"

# Ensure asdf shims take precedence
typeset -U path PATH
path=("$ASDF_DATA_DIR/shims" $path)

# ==========================================
# NODE.JS - Version Management
# ==========================================

# Show active Node.js and npm versions
nodeinfo() {
  echo "Node.js: $(node -v)"
  echo "npm:     $(npm -v)"
  echo ""
  asdf current nodejs
}

# List installed Node.js versions
nodels() {
  asdf list nodejs
}

# Install a Node.js version
nodeinstall() {
  if [[ -z "$1" ]]; then
    echo "Usage: nodeinstall <version|latest:24>"
    return 1
  fi

  asdf install nodejs "$1"
  asdf reshim nodejs
}

# Switch default Node.js version
nodeglobal() {
  if [[ -z "$1" ]]; then
    echo "Usage: nodeglobal <installed-version>"
    return 1
  fi

  asdf set -u nodejs "$1"
  nodeinfo
}

# Pin Node.js version for current project
nodelocal() {
  local version="${1:-$(node -v | sed 's/^v//')}"

  asdf set nodejs "$version"
  echo "Project Node.js pinned to $version"
}

# Upgrade Node.js within major version
nodeupgrade() {
  local major="${1:-24}"
  local version

  asdf plugin update nodejs || return 1
  version="$(asdf latest nodejs "$major")" || return 1

  [[ -n "$version" ]] || return 1

  asdf install nodejs "$version" || return 1
  asdf set -u nodejs "$version" || return 1
  asdf reshim nodejs

  rehash
  nodeinfo
}

# Convenient aliases
alias ni='npm install'
alias nr='npm run'
alias nd='npm run dev'
alias nb='npm run build'
alias nt='npm test'
alias nx='npx'
