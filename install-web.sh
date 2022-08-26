#!/usr/bin/env bash

if [[ $(whoami) != "root" ]]; then
	echo "this script requires root privileges" 1>&2
	exit
fi

function update_OS() {
	apt-get update &&
		apt-get upgrade -y
}

function install_packages() {
	apt-get install -y "$@"
}

function setup_website() {
	install_packages unzip apache2 || return 50
	pushd /tmp || return 255

	wget "https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip" || return 51
	unzip main.zip || return 52
	rm -rf /var/www/html
	mv --force linux-site-dio-main /var/www/html
	rm main.zip
	popd || return 255
}

function main() {
	update_OS &&
		setup_website &&
		echo "instalado com sucesso" 1>&2 &&
		service apache2 start && return 0
}

main
