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
function reflector_mirrorlist
{
	sudo pacman -Syy
	sudo pacman -Syu
	sudo pacman -S reflector 
	sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
	sudo reflector --verbose --country 'United States' -l 200 -p http --sort rate —-save /etc/pacman.d/mirrorlist
}

function devenv_init
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

function add_haskell_core_repo
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

function add_openrc_eudev_repo
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

function rotate_line
{
INTERVAL=1	# Sleep time between "twirls"
TCOUNT=0	# For each TCOUNT the line twirls one increment

	while :		# Loop forever...until this function is killed
	do
	TCOUNT=`expr $TCOUNT + 1`
	
	case $TCOUNT in
		"1") echo ’-’"\b\c"
			sleep $INTERVAL
			;;
		"2") echo ’\\’"\b\c"
			sleep $INTERVAL
			;;
		"3") echo "\|\b\c"
        		sleep $INTERVAL
        		;;
        	"4") echo "/\b\c" 
        		sleep $INTERVAL
        		;;
        	*)	TCOUNT="0" ;; # Reset the TCOUNT to "0", zero.
        esac
done
}

########################################################## 
# BEGINNING OF MAIN 
##########################################################

rotate_line & # Run the function in the background 
ROTATE_PID=$! # Capture the PID of the last background process


# End of script
