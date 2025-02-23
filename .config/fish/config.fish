# autoload -Uz compinit && compinit

set -gx PNPM_HOME /Users/liamcooper/Library/pnpm

set -gx PATH $(go env GOPATH)/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /Users/liamcooper/.local/bin $PATH
set -gx PATH /Users/liamcooper/.local/bin $PATH

set -gx PATH PNPM_HOME $PATH
#export PATH="$PATH:$PNPM_HOME"

#export PGDATA=/usr/local/var/postgresql@15

npm config set '//npm.fontawesome.com/:_authToken' "$FONTAWESOME_NPM_AUTH_TOKEN"
set -gx NVM_DIR ~/.nvm

set MANPAGER 'nvim +Man!'

# For config of dotfiles: https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

alias g="git"
alias gs="git status"
alias gp="git pull"
alias gb="git branch"
alias gch="git checkout"
alias gc="git commit"
alias ga="git add"
alias server="liamcoop@192.168.1.79"


alias dwr="dotnet watch run"
alias nr="npm run"

if test -f ~/.config/fish/env.fish
    source ~/.config/fish/env.fish
end

