#! /bin/sh

ln -sf /home/nix/nixfiles/awesome/colors/light.lua /home/nix/nixfiles/awesome/colors.lua
ln -sf /home/nix/nixfiles/xsettingsd/.lightd /home/nix/.xsettingsd
ln -sf /home/nix/nixfiles/rofi/colors/light.rasi /home/nix/nixfiles/rofi/colors.rasi
ln -sf /home/nix/nixfiles/kitty/light.conf /home/nix/.config/kitty/colors.conf

echo 'awesome.restart()' | awesome-client
pkill -USR1 kitty
xsettingsd

