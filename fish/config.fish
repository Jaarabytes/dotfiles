# Fish configuration

set -x PATH $HOME/.cargo/bin $PATH
# Set up the prompt
function fish_prompt
    set_color brblue
    echo -n "["
    set_color yellow
    echo -n (prompt_pwd)
    set_color brblue
    echo -n "] "
    set_color green
    echo -n "❯ "
    set_color normal
end

# Aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias exaa='exa -a'
alias ezaa='eza -a'
alias quit='exit'
alias lg='lazygit'
alias lzg='lazygit'
alias fishconfig='nvim ~/.config/fish/config.fish'
alias lzd='lazydocker'
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
alias greo='git remote set-url origin'
alias grao='git remote add origin'
alias ff='fastfetch'
alias pf='pfetch'
alias nf='neofetch'

alias country='curl ifconfig.co/country'
alias city='curl ifconfig.co/city'
alias src='source ~/.config/fish/config.fish'
alias vrc='source venv/bin/activate.fish'
alias venv='python -m venv venv'
alias nx='sudo nvim /etc/nixos/configuration.nix'
alias nxb='sudo nixos-rebuild switch'

# Environment variables
set -gx CODEBERG 'git@codeberg.org:tmlcherki/dotfiles.git'
set -gx GITLAB 'git@gitlab.com:Jaarabytes/dotfiles.git'
set -gx GITHUB 'git@github.com:Jaarabytes/dotfiles.git'

# Initialize zoxide
zoxide init fish | source

# Enable autosuggestions (assuming you have fish_autosuggestions installed)
if test -f /usr/share/fish/vendor_functions.d/fish_autosuggestions.fish
    source /usr/share/fish/vendor_functions.d/fish_autosuggestions.fish
    set -g fish_autosuggestion_color 999
end

# Enable command-not-found if available
if test -f /usr/share/fish/vendor_functions.d/command-not-found.fish
    source /usr/share/fish/vendor_functions.d/command-not-found.fish
end

# Set color scheme
set -U fish_color_normal normal
set -U fish_color_command 005fd7
set -U fish_color_quote 999900
set -U fish_color_redirection 00afff
set -U fish_color_end 009900
set -U fish_color_error ff0000
set -U fish_color_param 00afff
set -U fish_color_comment 990000
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 555
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan

# Optional: Add a greeting
function fish_greeting
    echo "Welcome to Fish shell! 🐟"
    echo "Current date: "(date)
    echo "System: "(uname -mrs)
end

# Optional: Add Fish-specific features
# Enable Vi mode
fish_vi_key_bindings

# Add custom key bindings
bind \co 'nvim .'  # Ctrl+O to open Neovim in current directory
bind \cf 'fzf'  # Ctrl+F to open fzf

# Load any local configurations
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end
