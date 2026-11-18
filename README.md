# dotfiles

My shell and terminal setup: zsh, git, bat, delta, oh-my-posh, and small
includes for Ghostty, kitty, foot, and Alacritty.

[mise](https://mise.jdx.dev) does all the work. It installs the packages and
tools, clones the zsh plugins, and links the files into place. There is no
Stow and there are no install scripts.

## Assumptions

- **Linux.** pacman, apt, and dnf are covered. mise skips the package
  managers a machine doesn't have.
- **mise is installed** (a recent release with `mise bootstrap` and
  `mise dot`). It's the only thing you install by hand.
- **The repo lives at `~/dotfiles`.** mise links to wherever the clone
  is, but the comments and the commands below use that path.
- **Omarchy is optional.** The base config works on any Linux. The
  Omarchy extras are a separate layer you turn on yourself (see below).

## Install

```sh
git clone https://github.com/DenizGazitepe/dotfiles.git ~/dotfiles
cd ~/dotfiles
mise trust

# On Omarchy only: turn on the Omarchy layer for this machine.
echo 'env = ["omarchy"]' > .miserc.toml

mise bootstrap plan   # preview
mise bootstrap        # install everything, then deploy the dotfiles
```

Open a new terminal afterwards. On Omarchy, the bun PATH change in
`~/.config/uwsm/env.d/bun` takes effect at the next login.

### Moving from the Stow setup

A machine set up before the switch to mise has two leftovers that mise
doesn't clean up. Run these once, before `mise bootstrap`:

```sh
# The old scripts added a foot include that mise's managed block would
# duplicate. This deletes only that exact block.
sed -i '/^# Settings owned by ~\/dotfiles; keep this last so they win$/{N;N;/\n\[main\]\ninclude=~\/\.config\/foot\/dotfiles\.ini$/d}' ~/.config/foot/foot.ini

# Stow links to files the repo no longer has (superfile, for one). This
# lists only dangling links into the repo; add -delete once the list looks right.
find ~ -xdev -xtype l -lname '*dotfiles/*' -print
```

The old include lines in the Ghostty and kitty configs can stay: mise
adopts them as they are.

### Day to day

| Command               | What it does                                     |
| --------------------- | ------------------------------------------------ |
| `mise dot diff`       | Show what `mise dot apply` would change          |
| `mise dot apply`      | Deploy the dotfiles only (no packages or tools)  |
| `mise dot status`     | Check that every entry is in place               |
| `mise bootstrap`      | Install anything missing, then deploy again      |
| `mup`                 | Update the mise tools now, without the release-age wait |

## What makes this repo different

- **zsh runs in the terminal, not as the login shell.** Each terminal's
  config starts `/usr/bin/zsh`, and the login shell stays the system's
  default. Launching a terminal with a command still runs that command
  directly.
- **Only zsh comes from the system.** The CLI tools (bat, delta, eza, fzf,
  zoxide, oh-my-posh, zsh-patina) are listed in
  `mise/.config/mise/conf.d/dotfiles.toml`. That file is linked into mise's
  global config, so the tools are on PATH in every directory. The zsh
  plugins (fzf-tab, zsh-autosuggestions, zsh-completions) are clones pinned
  to release tags. No plugin manager is needed.
- **The terminals' own configs are left alone.** The repo doesn't replace
  `ghostty/config`, `kitty.conf`, `foot.ini`, or `alacritty.toml`. mise adds
  one include line (or a marked block) at the end of each one, pointing to a
  `dotfiles.*` file. That way Omarchy or the machine can keep managing the
  main file, and the dotfiles settings still win. If a config is missing,
  mise creates it holding just the include.
- **Two layers.** `mise.toml` is the base for any Linux machine.
  `mise.omarchy.toml` loads on top of it when `MISE_ENV` includes `omarchy`.
  It adds Omarchy's shell environment, `EDITOR`/`BROWSER` launchers, the bun
  session PATH, and the Alacritty theme import, then reloads Hyprland and
  the terminal. The machine's choice lives in `.miserc.toml`, which git
  ignores. You can also set it for one run with `MISE_ENV=omarchy`.
- **Follows the terminal theme.** bat and delta use the `ansi` theme, so
  they pick up the terminal's palette, including after
  `omarchy theme set`.
- **zsh sources machine-specific files first.** `~/.zshrc` sources every
  `~/.config/zsh/conf.d/*.zsh` before its own defaults, which use
  `${VAR:-default}` so a machine layer can override them.

## Layout

Each top-level folder holds one program's files, laid out the way they sit
under `$HOME`. `mise.toml` maps each file to its target.

```
mise.toml               base layer: packages, plugin repos, dotfiles
mise.omarchy.toml       Omarchy layer
zsh/ git/ bat/ omp/     shell, git, pager, and prompt
mise/                   global tool list
ghostty/ kitty/ foot/   terminal includes
alacritty/
omarchy/                files only the Omarchy layer deploys
```
