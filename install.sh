#!/bin/sh
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

# Symlinks
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
link() {
    mkdir -p "$(dirname "$2")"
    ln -sfn "$1" "$2"
    echo "  $2 -> $1"
}

echo "Linking:"
link "$DOTFILES/zsh/zshrc"                   "$HOME/.zshrc"
link "$DOTFILES/tmux/tmux.conf"              "$HOME/.tmux.conf"
link "$DOTFILES/.vimrc"                      "$HOME/.vimrc"
link "$DOTFILES/git/gitconfig"               "$HOME/.gitconfig"
link "$DOTFILES/powerline-shell/config.json" "$HOME/.config/powerline-shell/config.json"
link "$DOTFILES/claude/statusline.sh"        "$HOME/.claude/statusline.sh"
link "$DOTFILES/claude/CLAUDE.md"            "$HOME/.claude/CLAUDE.md"

# Claude settings
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if command -v jq > /dev/null 2>&1; then
    [ -f "$CLAUDE_SETTINGS" ] || echo '{}' > "$CLAUDE_SETTINGS"
    tmp="$(mktemp)"
    if jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS" "$DOTFILES/claude/settings.json" > "$tmp"; then
        mv "$tmp" "$CLAUDE_SETTINGS"
        echo "Merged claude/settings.json into $CLAUDE_SETTINGS"
    else
        rm -f "$tmp"
        echo "Skipped settings.json merge ($CLAUDE_SETTINGS is not valid JSON)"
    fi
else
    echo "Skipped settings.json merge (jq not installed)"
fi

# macOS defaults
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
if [ "$OS" = "Darwin" ]; then
    sh "$DOTFILES/macos/defaults.sh"
    echo "Applied macos/defaults.sh (log out for key repeat to take effect)"
fi

# Dependencies
#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
missing=""
for c in zsh tmux vim git gh jq fzf rg powerline-shell; do
    command -v "$c" > /dev/null 2>&1 || missing="$missing $c"
done
if [ "$OS" != "Darwin" ]; then
    command -v xclip > /dev/null 2>&1 || command -v wl-copy > /dev/null 2>&1 \
        || missing="$missing xclip"
    fc-list ':charset=E0B0' 2>/dev/null | grep -q . \
        || missing="$missing fonts-powerline"
fi

if [ -n "$missing" ]; then
    echo
    echo "Not installed:$missing"
    echo "  ripgrep provides rg, and powerline-shell comes from pipx"
fi
