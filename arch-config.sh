#!/usr/bin/env sh
# created: 2015-01-02
# last revision: 2015-01-02
# author: ritchie latimore

cd /tmp
wget https://github.com/stuartpb/aur.sh/archive/master.zip
sudo unzip /tmp/master.zip

cd /tmp/aur.sh-master

if test ! -x aur.sh
then
	sudo chmod +x /tmp/aur.sh-master/aur.sh
fi

if test ! -x alt-aur.sh
then
	sudo chmod +x /tmp/aur.sh-master/alt-aur.sh
fi

sudo sed -i '/\[extra\]/i \
\[haskell\-core\] \
http\:\/\/xsounds\.org\/\~haskell\/core\/\$arch\n' /etc/pacman.conf

sudo pacman -Syy
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git cvs cvsps
sudo pacman -S --needed --noconfirm ghc
sudo pacman -S --needed --noconfirm haskell-regex-base haskell-parsec haskell-syb haskell-mtl haskell-json haskell-temporary

cd `mktemp -d`
bash <(curl /tmp/aur.sh-master/aur.sh) -si haskell-regex-pcre-builtin haskell-http-conduit
bash <(curl /tmp/aur.sh-master/aur.sh) -si aura
