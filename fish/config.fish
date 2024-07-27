if status is-interactive
    # Commands to run in interactive sessions can go here


set -U fish_color_normal fbf1c7
set -U fish_color_command 98971a

alias brightness='xrandr --output eDP-1 --brightness'

# Start the SSH agent
if not pgrep -u $USER ssh-agent > /dev/null
    eval (ssh-agent)


# Add SSH key if it's not already added
if not ssh-add -l | grep -q '~/.ssh/id_rsa/hi'
    ssh-add /path/to/my/ssh-key


alias ezaa='eza -a'
alias exaa='exa -a'
alias lg='lazygit'
alias gst='git status'
alias gsw='git switch'
alias gbr='git branch'
alias glg='git log'
alias gf='git fetch'
alias zshconfig='nvim ~/.zshrc'
alias bashconfig='nvim ~/.bashrc'
alias gch='git checkout'
alias gpl='git pull'
alias lzd='lazydocker'
alias gti='git'
