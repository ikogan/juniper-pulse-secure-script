#!/bin/bash
# SSL VPN Script based on openconnect
#
# The following packages are required for this to work:
# gksu zenity libssl-dev libxml2-dev vpnc-scripts
# 
# As well as a custom build of openconnect:
#
# wget ftp://ftp.infradead.org/pub/openconnect/openconnect-7.06.tar.gz
# tar xzf openconnect-7.06.tar.gz{
# cd openconnect-7.06
# ./configure --with-vpnc-script=/usr/share/vpnc-scripts/vpnc-script
# make
# sudo make install 
VPN_URL=

if [[ "${1}" = "start" ]]; then
	PID=$(ps aux | grep ${VPN_URL} | grep -v grep | awk '{ print $2 }')

	if [[ ! -z "${PID}" ]]; then
		zenity --error --title="SSL VPN" --text="SSL VPN already connected."
		exit 1
	fi

	if [[ ! "$(whoami)" = "root" ]]; then
		gksu -D "SSL VPN Connection" -u root "${0} ${1} $(whoami)"
	fi

	if [[ -z "${2}" ]]; then
		exit 0
	fi

	export LD_LIBRARY_PATH=/usr/local/lib

	PROCESS_USERNAME="${2}"
	DIALOG_OUTPUT=$(zenity --password --username --title="SSL VPN" --ok-label=Connect)
	DIALOG_OUTPUT=($(echo "${DIALOG_OUTPUT}" | tr '|' '\n'))
	LOGIN_USERNAME=${DIALOG_OUTPUT[0]}
	LOGIN_PASSWORD=${DIALOG_OUTPUT[1]}

	yes | zenity --progress --no-cancel --pulsate --title="SSL VPN" --width 350 --text="Connecting..." --auto-close &>/dev/null &
	PROGRESS_PID=$!

	echo ${LOGIN_PASSWORD} | /usr/local/sbin/openconnect --juniper "${VPN_URL}" -U "${PROCESS_USERNAME}" -b -l --timestamp -u "${LOGIN_USERNAME}" --no-cert-check --passwd-on-stdin &>/dev/null
	RESULT=$?

	kill ${PROGRESS_PID} 2>/dev/null

	if [[ ! "${RESULT}" = "0" ]]; then
		zenity --error --title="SSL VPN" --text="Unable to connect. Check syslog for details." &>/dev/null
	else
		zenity --info --title="SSL VPN" --text="Connection complete." &>/dev/null
	fi
elif [[ "${1}" = "stop" ]]; then
	PID=$(ps aux | grep ${VPN_URL} | grep -v grep | awk '{ print $2 }')

	if [[ ! -z "${PID}" ]]; then
		kill ${PID}
	else
		zenity --error --title="SSL VPN" --text="SSL VPN is not running."
	fi
fi
