rsync -aq ./nvim/init.lua ~/.config/nvim/init.lua
rsync -aqr --delete ./nvim/lua ~/.config/nvim
rsync -aqr --delete ./nvim/after ~/.config/nvim

echo "Dotfiles installed!"
