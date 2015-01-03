#!/usr/bin/env sh
# SCRIPT: arch-config.sh 
# AUTHOR: Ritchie J Latimore 
# DATE: 2015-01-03
# Rev: 0.0.1a  
#
# REV LIST: 0.0.1a
# PLATFORM: arch, archbang
# PURPOSE: workstation/server setup on arch & archbang linux
########################################################## 
# DEFINE FILES AND VARIABLES HERE 
##########################################################



########################################################## 
# DEFINE FUNCTIONS HERE 
##########################################################
function mirrorl_rank
{
	sudo pacman -Syy
	sudo pacman -Syu
	sudo pacman -S reflector 
	sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
	sudo reflector --verbose --country 'United States' -l 200 -p http --sort rate —-save /etc/pacman.d/mirrorlist
}

function devenv
{
	sudo pacman -S --needed base-devel git cvs cvsps perl-libwww perl-term-readkey perl-mime-tools perl-net-smtp-ssl perl-authen-sasl subversion rsync fakeroot
}

function dirmngr_pacman_key_init
{
	sudo dirmngr > /dev/null 2>&1 &
	sleep 10
	sudo pacman-key --init
	sleep 10
	sudo pacman-key --populate
	sleep 10
}

function add_haskell_core
{
	sudo sed -i '/\[extra\]/i \
		\[haskell\-core\] \
		Server\ \=\ http\:\/\/xsounds\.org\/\~haskell\/core\/\$arch\n' /etc/pacman.conf
	sudo pacman-key -r 4209170B
	sleep 5
	sudo pacman-key --lsign-key 4209170B
	sudo pacman -Syu
	sleep 5
}

function add_openrc_eudev
{
	sudo sed -i '/\[extra\]/i \
	\[openrc-eudev\] \
	SigLevel\ \=\ Optional\ TrustAll \
	Server\ \=\ https\:\/\/downloads\.sourceforge\.net\/projects\/mefiles\/Manjaro\/\$repo\/\$arch\n'
	sudo pacman-key -r 518B147D
	sleep 5
	sudo pacman-key --lsign-key 518B147D
	sudo pacman -Syu
	sleep 5
}

function aur_sh_init
{
	cd /tmp
	sudo wget https://github.com/stuartpb/aur.sh/archive/master.zip
	sudo unzip /tmp/master.zip
	cd /tmp/aur.sh-master
	
	if [ ! -x aur.sh ]
		then
		sudo chmod +x /tmp/aur.sh-master/aur.sh
	fi

	if [ ! -x alt-aur.sh ]
		then
		sudo chmod +x /tmp/aur.sh-master/alt-aur.sh

	fi

	cd `mktemp -d`
	cp /tmp/aur.sh-master/aur.sh .
}

function aura_bin_init
{
	aura_sh_init
	bash <(curl aur.sh) -si aura-bin
}

function aura_src_init
{
	aura_sh_init
	sudo pacman -S --needed ghc
	sudo pacman -S --needed haskell-regex-base haskell-parsec haskell-syb haskell-mtl haskell-json haskell-temporary
	bash <(curl aur.sh) -si haskell-regex-pcre-builtin haskell-http-conduit haskell-reflection haskell-lens haskell-lens-aeson haskell-psqueue haskell-wreq haskell-aur aura
}

function openrc_init
{
	sudo aura -S openrc-base
	sudo aura -S openrc-desktop
	sudo aura -S networkmanager-openrc alsa-utils-openrc acpid-openrc
	sudo rc-update add acpid default
	sudo aura -S pm-utils consolekit-openrc
	sudo aura -S eudev-openrc eudev eudev-systemdcompat upower-pm-utils-eudev
}
########################################################## 
# BEGINNING OF MAIN 
##########################################################




# End of script
