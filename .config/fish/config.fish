addToPath $(go env GOPATH)/bin
addToPath /opt/homebrew/bin
addToPath ~/.local/bin
addToPath ~/.local/bin/scripts
addToPath PNPM_HOME

set MANPAGER 'nvim +Man!'

set -gx NVM_DIR ~/.nvm

bind \cf 'tmux-sessionizer'

if test -f ~/.config/fish/env.fish
    source ~/.config/fish/env.fish
end

if test -f ~/.config/fish/abbr.fish
    source ~/.config/fish/abbr.fish
end

if test -f ~/.config/fish/alias.fish
    source ~/.config/fish/alias.fish
end

task --completion fish | source
