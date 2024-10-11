export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias exaa='exa -a'
alias ezaa='eza -a'
# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# Created by `pipx` o:n 2024-04-24 15:02:06
alias lg='lazygit'
alias lzg='lazygit'
alias zshconfig='nvim ~/.zshrc'
alias lzd='sudo chmod 666 /var/run/docker.sock && lazydocker'
alias gp='git push'
alias gpl='git pull'
alias gpsh='git push'
alias gst='git status'
alias gsw='git switch'
alias gl='git log'
alias glg='git log'
alias gbr='git branch'
alias gch='git checkout'
alias gcl='git clone'
alias gf='git fetch'
alias fu='foundryup'
alias gpl='git pull'
alias greo='git remote set-url origin'
alias grao='git remote add origin'
alias ff='fastfetch'
alias src='source ~/.zshrc'


alias nx='sudo nvim /etc/nixos/configuration.nix'
alias nxb='sudo nixos-rebuild switch'
eval "$(zoxide init zsh)"
export CODEBERG='git@codeberg.org:tmlcherki/dotfiles.git'
export GITLAB='git@gitlab.com:Jaarabytes/dotfiles.git'
export GITHUB='git@github.com:Jaarabytes/dotfiles.git'
