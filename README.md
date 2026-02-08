# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
./stow.sh
```

Each top-level directory is a stow package that mirrors `$HOME`. For example:

```
nvim/.config/nvim/init.lua  ->  ~/.config/nvim/init.lua
leetcode/.leetcode/leetcode.toml  ->  ~/.leetcode/leetcode.toml
```

To add a single package: `stow <package>`
To remove a single package: `stow -D <package>`

## Secrets

Some packages reference secrets via environment variables. These are sourced from files that live only on the local machine and are never committed:

- **`~/.leetcode_secrets`** — `LEETCODE_CSRF` and `LEETCODE_SESSION` for leetcode-cli
