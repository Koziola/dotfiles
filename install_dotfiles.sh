# rewrite this using Go or something - bash is pain


function symlink() {
  local file=$1
  local destination=$2
  local full_file_path="$PWD/$file"

  if [ ! -e $destination ]; 
  then
    ln -s $full_file_path $destination
    echo "[ADDED] $full_file_path -> $destination"
  else
    echo "[SKIPPED] $full_file_path -> $destination"
  fi
}

function install_local() {
    symlink nvim/init.lua ~/.config/nvim/init.lua
    symlink nvim/lua ~/.config/nvim/lua
    symlink nvim/after ~/.config/nvim/after
}

# used to copy dotfiles to a remote machine
function install_remote() {
    rsync -aq ./nvim/init.lua ~/.config/nvim/init.lua
    rsync -aqr --delete ./nvim/lua ~/.config/nvim
    rsync -aqr --delete ./nvim/after ~/.config/nvim
}

install_local

echo "[SUCCESS] Dotfiles installed!"
