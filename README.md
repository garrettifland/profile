# Overview
My shell and editor profiles are a mixed bag of shortcuts and custom functions, to the point where I can hardly function on a machine without them. Over the years I have stolen many tricks from peers, and shared my own configurations with others as well. This repo is a sanitized subset of my own configuration for others to use in their own quests for terminal efficiency. The primary goal of this configuration is to minimize the cognitive overhead associated with switching environments by relying on common configuration for MacOS and Linux desktops and remote hosts.

# What
The following are the primary components for my cross-platform dev environment:
- Alacritty
- Tmux
- NeoVim
- ZSH

# Setup
If any of the following files exist, be sure to back them up before proceeding:
```
.bashrc
.config/alacritty/alacritty.yml
.config/git/ignore
.config/nvim/autoload/plug.vim
.config/nvim/init.vim
.gitconfig
.gitignore
.ssh/config
.tmux.conf
.zshrc
```

Initialize your profile with the following (in your home directory):

```bash
git init
git remote add origin <repo>  # you should fork this repo or start your own from scratch
git fetch
git checkout master
```

In a new shell, run `setup-deps` (defined in `.bashrc`) to install most of the primary dependencies.

# Usage
In order to avoid merge pain (if using multiple machines), commit and push any environment configuration changes immediately.

# Machine-Local Configuration
Sometimes I have shell configuration that should be scoped to a specific machine (like specific shortcuts for work on a work machine), I put these in a file `~/.secretrc` that is sourced by `bash` and `zsh` - this way I can still share common configuration between all machines in `git` without need to manually cherry-pick changes into a single rc file.
