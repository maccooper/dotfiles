addToPath $(go env GOPATH)/bin
addToPath /opt/homebrew/bin
addToPath ~/.local/bin
addToPath ~/.local/bin/scripts
addToPath PNPM_HOME

set MANPAGER 'nvim +Man!'

set -gx DOTFILES_DIR $HOME/.dotfiles
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

starship init fish | source

#task --completion fish | source

# alt ssh liamcooper@homelab
abbr sshhomelab  'ssh liamcooper@100.122.140.127'
# alt: ssh liamcooper@mediaserver
abbr sshmedia  'ssh liamcooper@100.83.103.5'
abbr sshepbc 'ssh liamcooper@100.104.205.105'
abbr sshpersonal 'ssh liamcooper@100.66.244.15'

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
if status is-interactive
    and not set -q TMUX
        tmux
end
