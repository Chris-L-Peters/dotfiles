# dotfiles

Aims for cross-platform cross-application consistency of
- Colour Scheme: One Dark
- Navigation: Vim keys
- Pane switching: ctrl/alt vim keys
- Pane splitting: Vim/tmux style

Setting and keymappings for
- Vim
- Tmux
- Zsh
- VSCode
- Jupyter Notebook
- Anne Pro 2

## Layout

| File | Installs to |
| --- | --- |
| `tmux/tmux.conf` | `~/.tmux.conf` (symlink) |
| `zsh/zshrc` | `~/.zshrc` (symlink) |
| `git/gitconfig` | `~/.gitconfig` (symlink) |
| `powerline-shell/config.json` | `~/.config/powerline-shell/config.json` (symlink) |
| `.vimrc` | `~/.vimrc` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` (symlink) |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` (symlink) |
| `claude/settings.json` | merged into `~/.claude/settings.json` |
| `macos/defaults.sh` | run once, writes to `defaults` |

Setup, on macOS or Linux:

```sh
git clone https://github.com/Chris-L-Peters/dotfiles.git
cd dotfiles
./install.sh
```

`install.sh` creates symlinks and merges `claude/settings.json` into
`~/.claude/settings.json` with `jq`, keeping any keys already there. It applies
`macos/defaults.sh` on macOS, and reports any dependency it cannot find on
`$PATH`. It installs no packages and is safe to re-run.

Dependencies, installed however the platform prefers:

| Package | For |
| --- | --- |
| `zsh` | the shell itself |
| `tmux`, `vim`, `git` | the configs in this repo |
| `fzf` | `Ctrl-R` / `Ctrl-T` / `Alt-C` |
| `ripgrep` | fzf's file source |
| `jq` | the Claude status line |
| `powerline-shell` | the prompt, via `pipx install powerline-shell` |
| `xclip` or `wl-copy` | tmux clipboard on Linux |
| `fonts-powerline` | the prompt's separator glyphs on Linux |

Then set the login shell. The prompt needs the Powerline glyphs in
`U+E0A0`-`U+E0B3`: on Linux `fonts-powerline` adds them to whatever font the
terminal already uses, and on macOS SF Mono Terminal already has them.

```sh
chsh -s "$(command -v zsh)"
```

### Platform differences

| Thing | Handling |
| --- | --- |
| Clipboard | tmux yanks to `pbcopy` on macOS, else `wl-copy` under Wayland or `xclip` under X11 |
| `set-clipboard` | left on for terminals that honour OSC 52; VTE (Ptyxis, GNOME Terminal) ignores it |
| Homebrew | `zshrc` evaluates `shellenv` only if brew is present |
| fzf | uses `fzf --zsh` on 0.48+, otherwise sources the distro's key-binding files |
| `macos/defaults.sh` | run by `install.sh` on macOS only |
| Prompt glyphs | `fonts-powerline` on Linux, built into SF Mono Terminal on macOS |

## Shell

`zsh/zshrc` uses emacs key bindings (`bindkey -e`), set explicitly so zsh does
not switch to vi mode on its own when `$EDITOR` looks like vim, plus the
readline behaviour zsh does not match out of the box:

| Key | Does | Note |
| --- | --- | --- |
| `Ctrl-U` | delete to start of line | zsh default kills the whole line |
| `Home` / `End` / `Delete` | as labelled | bound for all common terminal sequences |
| `Ctrl-Left` / `Ctrl-Right` | move by word | also `Alt-Left` / `Alt-Right` |
| `Ctrl-X Ctrl-E` | edit the line in `$EDITOR` | unbound in zsh by default |
| `Ctrl-S` | forward history search | freed by `stty -ixon` |

`WORDCHARS` drops `/` and `=` so word motions stop at path components.

fzf provides `Ctrl-R` history search, `Ctrl-T` file search and `Alt-C` directory
jump, themed to One Dark. `ripgrep` supplies the file list, so searches respect
`.gitignore` and include dotfiles while skipping `.git`. The zshrc falls back to
fzf's built-in walker if `rg` is absent.

Homebrew's `shellenv` is evaluated from `zshrc` as well as `zprofile`, so the
interactive setup works in non-login shells where `zprofile` never runs.

## Git

`git/gitconfig` sets the commit identity plus `init.defaultBranch = main`,
`pull.rebase = true`, `push.autoSetupRemote = true` and `core.editor = vim`.

## Prompt

[powerline-shell](https://github.com/b-ryan/powerline-shell) renders the prompt,
using its stock `default` theme. `zsh/zshrc` installs it as a `precmd` hook. For
bash, add to `~/.bashrc`:

```sh
_update_ps1() {
    PS1=$(powerline-shell $?)
}
if [ "$TERM" != "linux" ] && command -v powerline-shell > /dev/null 2>&1; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
```

### Segments

Left to right, as configured in `config.json`:

| Segment | Background | Shown |
| --- | --- | --- |
| `virtual_env` | 35 green | inside a python virtualenv |
| `username` | 240 grey | always |
| `ssh` | 166 orange | over SSH, shows `SSH` not the host name |
| `cwd` | 31 blue for `~`, 237 for the path | always |
| `git` | 148 green clean / 161 red dirty | inside a git repo |
| `hg` | as git | inside a mercurial repo |
| `jobs` | 238 | background jobs running |
| `root` | 236, turns 161 red | always |

`hostname` is deliberately omitted to keep the prompt short. Nothing else
prints the host, so an SSH session shows the `ssh` marker but not which
machine it is.

The trailing `root` segment holds the `$` and turns red when the previous
command exited non-zero; there is no separate exit-code segment.

Path components each get their own sub-segment joined by thin separators, with
the final component brightened to 254. Paths deeper than five components are
elided with `…`.

### Font

Requires a Powerline-patched or Nerd Font:

| Glyph | Codepoint | Use |
| --- | --- | --- |
| `` | U+E0B0 | segment separator |
| `` | U+E0B1 | path separator |

## Claude Code status line

`claude/statusline.sh` prints the model and context usage, colour-coded by how
full the context window is: green under 60%, yellow to 85%, red above.

Enable it in `~/.claude/settings.json` (not tracked here, it holds machine
specific config):

```json
"statusLine": {
  "type": "command",
  "command": "~/.claude/statusline.sh",
  "padding": 0
}
```

## macOS defaults

`macos/defaults.sh` sets the repeat rate to match a stock Windows machine,
which is roughly three times faster than the macOS default and is what PuTTY
inherits. The initial delay is left at the macOS default, already shorter than
Windows:

| Setting | Value | Result | Windows |
| --- | --- | --- | --- |
| `KeyRepeat` | 2 | 30ms between repeats | ~33ms |
| `InitialKeyRepeat` | 25 | 375ms before repeating | ~500ms |
| `ApplePressAndHoldEnabled` | false | holding a key repeats instead of opening the accent picker | n/a |

Values are in 15ms ticks. `defaults` reaches below the System Settings slider
minimum, so `KeyRepeat 1` (15ms) is available if 2 still feels slow.

Run it, then log out and back in:

```sh
./macos/defaults.sh
```
