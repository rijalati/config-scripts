#!/usr/bin/env bash
# created: 2015-01-02
# last revision: 2015-01-02
# author: ritchie latimore

cd /tmp
sudo pacman -Syy
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git cvs cvsps2 perl-libwww perl-term-readkey perl-mime-tools \
perl-net-smtp-ssl perl-authen-sasl subversion 

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
Server\ \=\ http\:\/\/xsounds\.org\/\~haskell\/core\/\$arch\n' /etc/pacman.conf

sudo dirmngr --daemon > /dev/null 2>&1
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman-key -r 4209170B
sudo pacman-key --lsign-key 4209170B

sudo pacman -S --needed --noconfirm ghc
sudo pacman -S --needed --noconfirm haskell-regex-base haskell-parsec haskell-syb haskell-mtl haskell-json haskell-temporary

cd `mktemp -d`
bash <(curl /tmp/aur.sh-master/aur.sh) -si haskell-regex-pcre-builtin haskell-http-conduit
bash <(curl /tmp/aur.sh-master/aur.sh) -si aura
