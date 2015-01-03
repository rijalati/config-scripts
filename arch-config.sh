#!/usr/bin/env bash
# created: 2015-01-02
# last revision: 2015-01-02
# author: ritchie latimore


sudo pacman -Syy
sudo pacman -Syu
sudo pacman -S reflector 
#sudo passwd root
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
sudo reflector --verbose --country 'United States' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -S --needed base-devel git cvs cvsps2 perl-libwww perl-term-readkey perl-mime-tools \
perl-net-smtp-ssl perl-authen-sasl subversion rsync


sudo sed -i '/\[extra\]/i \
\[haskell\-core\] \
Server\ \=\ http\:\/\/xsounds\.org\/\~haskell\/core\/\$arch\n\n' /etc/pacman.conf

sudo dirmngr > /dev/null 2>&1 &
wait 10
sudo pacman-key --init
wait 10
sudo pacman-key --populate
wait 10
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
cp /tmp/aur.sh-master/aur.sh .
bash <(curl aur.sh) -si haskell-regex-pcre-builtin haskell-http-conduit
bash <(curl aur.sh) -si aura
