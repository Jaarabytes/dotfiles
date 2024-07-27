if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -U fish_color_normal fbf1c7
set -U fish_color_command 98971a

function brightness
  xrandr --output eDP-1 --brightness
end

function ezaa
  eza -a
end

function exaa
  exa -a
end

function lg
  lazygit
end

function gst
  git status
end

function gsw
  git switch
end

function gbr
  git branch
end

function glg 
  git log
end

function gf
  git fetch
end

function zshconfig
  nvim ~/.zshrc
end

function bashconfig
  nvim ~/.bashrc
end

function gch
  git checkout 
end

function gpl
  git pull
end

function lzd
  lazydocker
end

function gti
  git
end
