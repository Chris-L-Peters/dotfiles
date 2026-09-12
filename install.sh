#!/bin/sh
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"
LINKS_ONLY="${1:-}"

# Packages
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
install_packages() {
    if [ "$OS" = "Darwin" ]; then
        if ! command -v brew > /dev/null 2>&1; then
            echo "Homebrew is required: https://brew.sh" >&2
            exit 1
        fi
        brew install pipx fzf ripgrep jq tmux vim
    elif command -v apt-get > /dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y zsh tmux vim git curl jq fzf ripgrep pipx xclip
    elif command -v pacman > /dev/null 2>&1; then
        sudo pacman -S --needed --noconfirm zsh tmux vim git curl jq fzf ripgrep python-pipx xclip
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf install -y zsh tmux vim git curl jq fzf ripgrep pipx xclip
    else
        echo "Unknown package manager. Install manually:" >&2
        echo "  zsh tmux vim git curl jq fzf ripgrep pipx xclip" >&2
    fi

    pipx install powerline-shell > /dev/null 2>&1 \
        || pipx upgrade powerline-shell > /dev/null 2>&1 \
        || true
}

# Symlinks
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
link() {
    mkdir -p "$(dirname "$2")"
    ln -sfn "$1" "$2"
    echo "  $2 -> $1"
}

link_all() {
    link "$DOTFILES/zsh/zshrc"                   "$HOME/.zshrc"
    link "$DOTFILES/tmux/tmux.conf"              "$HOME/.tmux.conf"
    link "$DOTFILES/.vimrc"                      "$HOME/.vimrc"
    link "$DOTFILES/git/gitconfig"               "$HOME/.gitconfig"
    link "$DOTFILES/powerline-shell/config.json" "$HOME/.config/powerline-shell/config.json"
    link "$DOTFILES/claude/statusline.sh"        "$HOME/.claude/statusline.sh"
    link "$DOTFILES/claude/CLAUDE.md"            "$HOME/.claude/CLAUDE.md"
}

# Run
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
if [ "$LINKS_ONLY" != "--links-only" ]; then
    install_packages
fi

echo "Linking:"
link_all

if [ "$OS" = "Darwin" ]; then
    sh "$DOTFILES/macos/defaults.sh"
    echo "Applied macos/defaults.sh (log out for key repeat to take effect)"
fi

cat <<'EOF'

Remaining manual steps:
  chsh -s "$(command -v zsh)"
  install a Powerline-patched or Nerd Font, select it in your terminal
  add the statusLine block from README.md to ~/.claude/settings.json
EOF
