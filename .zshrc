alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

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
export PATH="$PATH:/snap/bin"

export PATH="$PATH:/go/bin"
alias brightness='xrandr --output eDP-1 --brightness'
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH=$PATH:$(npm bin -g)
export PATH=$PATH:/snap/bin

# Created by `pipx` o:n 2024-04-24 15:02:06
export PATH="$PATH:/home/trafalgar/.local/bin"
alias lg='lazygit'
alias zshconfig='nvim ~/.zshrc'
alias lzd='sudo chmod 666 /var/run/docker.sock && lazydocker'
alias gp='git push'
alias gst='git status'
alias gsw='git switch'
alias gl='git log'
alias gb='git branch'
alias gc='git checkout'
alias gf='git fetch'
alias fu='foundryup'
alias gpl='git pull'
