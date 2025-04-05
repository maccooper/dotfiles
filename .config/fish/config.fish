# autoload -Uz compinit && compinit

set -gx PNPM_HOME /Users/liamcooper/Library/pnpm

set -gx PATH $(go env GOPATH)/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH /Users/liamcooper/.local/bin $PATH
set -gx PATH /Users/liamcooper/.local/bin $PATH
set -gx PATH $HOME/.local/bin/scripts $PATH

set -gx PATH PNPM_HOME $PATH
#export PATH="$PATH:$PNPM_HOME"

npm config set '//npm.fontawesome.com/:_authToken' "$FONTAWESOME_NPM_AUTH_TOKEN"
set -gx NVM_DIR ~/.nvm

set MANPAGER 'nvim +Man!'

alias find='echo "Using fd instead of find!"; fd'
alias cat='echo "Using cat instead of bat!"; bat'

# For config of dotfiles: https://www.atlassian.com/git/tutorials/dotfiles
# Consider using git stow to handle install + symlinking
abbr config /usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME
abbr sshserver ssh liamcoop@100.109.140.25 -p 50022

abbr g git
abbr gco git checkout
abbr gc git commit
abbr gs git status
abbr ga git add
abbr gp git pull
abbr gb git branch
abbr dwr dotnet watch run
abbr nr npm run
abbr find fd

set -gx SERVER_IP '192.168.0.74'
alias server="-p 50022 liamcoop@$SERVER_IP"

# connect to sfu welcome
alias welcome="-l lca168 -p 3222 welcomeepbc.its.sfu.ca"
# needs to be executed after ssh welcome
# alias jump="liam@epbc-jump.epbc.sfu.ca"

bind \cf 'tmux-sessionizer'

if test -f ~/.config/fish/env.fish
    source ~/.config/fish/env.fish
end

task --completion fish | source
