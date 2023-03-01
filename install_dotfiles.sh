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

if [ ! -d ~/.config/nvim ]; then
  mkdir -p ~/.config/nvim
fi

install_local

echo "[SUCCESS] Dotfiles installed!"
