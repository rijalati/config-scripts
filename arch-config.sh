#!/usr/bin/env bash
# created: 2015-01-02
# last revision: 2015-01-02
# author: ritchie latimore

sudo pacman -Syy
sudo pacman -Syu
sudo pacman -S --needed base-devel git cvs cvsps2 perl-libwww perl-term-readkey perl-mime-tools \
perl-net-smtp-ssl perl-authen-sasl subversion 

sudo sed -i '/\[extra\]/i \
\[haskell\-core\] \
Server\ \=\ http\:\/\/xsounds\.org\/\~haskell\/core\/\$arch\n\n' /etc/pacman.conf

sudo dirmngr > /dev/null 2>&1 &
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman-key -r 4209170B
sudo pacman-key --lsign-key 4209170B

sudo pacman -Syy
sudo pacman -S --needed ghc
sudo pacman -S --needed haskell-regex-base haskell-parsec haskell-syb haskell-mtl haskell-json haskell-temporary

cd /tmp
sudo wget https://github.com/stuartpb/aur.sh/archive/master.zip
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

cd `mktemp -d`
bash <$(curl /tmp/aur.sh-master/aur.sh) -si haskell-regex-pcre-builtin haskell-http-conduit
bash <$(curl /tmp/aur.sh-master/aur.sh) -si aura
