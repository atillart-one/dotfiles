#! /bin/sh
rm -rf /home/nix/nixfiles/awesome/theme.lua
ln -s /home/nix/nixfiles/awesome/colors/dark.lua /home/nix/nixfiles/awesome/theme.lua
rm -rf /home/nix/nixfiles/nvim/custom/chadrc.lua
ln -s /home/nix/nixfiles/nvim/custom/dark.lua /home/nix/nixfiles/nvim/custom/chadrc.lua
rm -rf /home/nix/.config/kitty/theme.conf
ln -s /home/nix/nixfiles/kitty/dark.conf /home/nix/.config/kitty/theme.conf
pkill -10 kitty
killall pa-applet
echo 'awesome.restart()' | awesome-client
xsettingsd -c /home/nix/.darkd
