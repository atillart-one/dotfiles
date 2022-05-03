#! /bin/sh

ln -sf /home/nix/nixfiles/awesome/colors/dark.lua /home/nix/nixfiles/awesome/colors.lua
ln -sf /home/nix/nixfiles/xsettingsd/.darkd /home/nix/.xsettingsd
ln -sf /home/nix/nixfiles/rofi/colors/dark.rasi /home/nix/nixfiles/rofi/colors.rasi
ln -sf /home/nix/nixfiles/kitty/dark.conf /home/nix/.config/kitty/colors.conf

echo 'awesome.restart()' | awesome-client
pkill -USR1 kitty
xsettingsd
